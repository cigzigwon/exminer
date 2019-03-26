defmodule Miner.Crawler do
	alias Miner.Crawler.Cache
	require IO

	@asynctimeout 8000
	@notallowed ["mailto:", "tel:", "ftp:", "#", "javascript:", "@"]

	def get(url) do
		if Cache.get("domain") == nil do
			url |> set_domain
		end

		task = Task.Supervisor.async_nolink(Miner.TaskSupervisor, fn -> spawn_task(url) end)
		Task.await(task, @asynctimeout)
	end

	def set_domain(url) do
		uri = url |> URI.parse
		Cache |> Cache.put("domain", uri.scheme <> "://" <> uri.host)
	end

	defp spawn_task(url) do
		url
		|> parse_url
		|> fetch_body
		|> refs
		|> fix
		|> sanitize
		|> cache
		|> crawl
	end

	defp crawl(links) do
		links
		|> Enum.each(fn url ->
			if Cache.get(url).crawl do
				Cache |> Cache.put(url, %{crawl: false})
				get(url)
			end
		end)
		links
	end

	defp parse_url(url) do
		case url |> URI.parse do
			%URI{scheme: nil} ->
				parse_url("https://#{url}")
			%URI{path: nil} ->
				parse_url("#{url}/")
			%URI{} ->
				url |> URI.parse
		end
		|> to_string
	end

	defp refs(body) do
		body
		|> Floki.find("a")
		|> Floki.attribute("href")
	end

	defp fetch_body(url) do
		if Mix.env != :test do
			peek url
		end
		
		case HTTPoison.get url do
			{:ok, %{body: body}} -> body
			_ -> ""
		end
	end

	defp cache(links) do
		links
		|> Enum.each(fn link -> if Cache.get(link) == nil, do: Cache |> Cache.put(link, %{crawl: true}) end)
		links
	end

	defp fix(links) do
		links
		|> Enum.map(fn url -> if url |> String.match?(~r/^\/(\w+|\d+)/), do: Cache.get("domain") <> url, else: url end)
	end

	defp in_scope?(url) do
		domain = Cache.get("domain")
		url |> String.match?(~r/^#{domain}/)

	end

	defp peek(data) do
		IO.inspect data
		data
	end

	defp sanitize(links) do
		links
		|> Enum.filter(fn url -> url |> is_valid? end)
	end

	defp is_valid?(url) do
		if url |> String.length > 1 and not String.contains?(url, @notallowed) and in_scope?(url) do
			true
		else 
			false
		end
	end
end