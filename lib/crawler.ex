defmodule Miner.Crawler do
  require Logger
  use GenServer

  @notallowed ["mailto:", "tel:", "ftp:", "#", "javascript:", "@"]

  def start_link(opts) do
    GenServer.start_link(
      __MODULE__,
      Keyword.fetch!(opts, :url),
      opts
    )
  end

  @impl true
  def init(url) do
    state = %{
      init: url,
      last: nil,
      next: url
    }

    {:ok, state, {:continue, :crawl}}
  end

  def fetch(url, state) do
    Logger.info("Fetching URL: #{url}")

    url
    |> parse_url
    |> fetch_body
    |> refs
    |> fix(state[:init])
    |> sanitize(state[:init])
  end

  def lookup(url) do
    Registry.lookup(Registry.SitemapRepo, url)
  end

  def html(url) do
    case Registry.lookup(Registry.SitemapRepo, url)
         |> Enum.find(fn {_, data} ->
           !is_list(data)
         end) do
      {_, html} ->
        html

      res ->
        res
    end
  end

  def urls(pid) do
    Registry.keys(Registry.SitemapRepo, pid)
    |> Enum.reduce("", fn url, acc ->
      if String.contains?(acc, url) do
        acc
      else
        acc <> "#{url}\n"
      end
    end)
  end

  @impl true
  def handle_continue(:crawl, state = %{next: urls}) when is_list(urls) do
    urls =
      urls
      |> Enum.reduce([], fn url, acc ->
        urls =
          case lookup(url) do
            [] ->
              urls = fetch(url, state)
              Registry.register(Registry.SitemapRepo, url, urls)
              urls

            _ ->
              []
          end

        acc ++ urls
      end)

    state = Map.put(state, :next, urls)

    if length(urls) > 0 do
      {:noreply, state, {:continue, :crawl}}
    else
      {:noreply, state}
    end
  end

  @impl true
  def handle_continue(:crawl, state = %{next: url}) do
    Logger.info("Crawling domain #{url} .....")
    urls = fetch(url, state)
    state = Map.put(state, :next, urls)

    if length(urls) > 0 do
      Registry.register(Registry.SitemapRepo, url, urls)
      {:noreply, state, {:continue, :crawl}}
    else
      {:noreply, state}
    end
  end

  @impl true
  def terminate(:shutdown, state) do
    Logger.info("Process shutdown: #{state[:init]}")
  end

  @impl true
  def terminate(reason, _) do
    IO.puts(reason)
    Logger.info("Process crashed")
  end

  defp parse_url(url) do
    case url |> URI.parse() do
      %URI{scheme: nil} ->
        parse_url("https://#{url}")

      %URI{path: nil} ->
        parse_url("#{url}/")

      %URI{} ->
        url |> URI.parse()
    end
    |> to_string
  end

  defp refs(body) do
    body
    |> Floki.find("a")
    |> Floki.attribute("href")
  end

  defp fetch_body(url) do
    response =
      Task.async(fn ->
        HTTPoison.get(url)
      end)

    body =
      case Task.await(response) do
        {:ok, %{body: body}} -> body
        _ -> ""
      end

    Registry.register(Registry.SitemapRepo, url, body)
    body
  end

  defp fix(links, scope) do
    links
    |> Enum.map(fn url ->
      if url |> String.match?(~r/^\/(.*)/),
        do: (scope <> url) |> parse_url(),
        else: url
    end)
  end

  defp in_scope?(url, scope) do
    url |> String.match?(~r/^#{scope}/)
  end

  defp sanitize(links, scope) do
    links
    |> Enum.filter(fn url -> url |> is_valid?(scope) end)
  end

  defp is_valid?(url, scope) do
    if url |> String.length() > 1 and not String.contains?(url, @notallowed) and
         in_scope?(url, scope) do
      true
    else
      false
    end
  end
end
