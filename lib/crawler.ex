defmodule Miner.Crawler do
	alias Miner.Crawler.Cache
	require IO

	@notallowed ["mailto:", "tel:", "ftp:"]

	def get(url) do
		Cache |> Cache.put("domain", url)
		url
		|> fetch_body
		|> refs
		|> fix
		|> sanitize
		|> cache
	end

	def refs(body) do
		body
		|> Floki.find("a")
		|> Floki.attribute("href")
	end

	defp fetch_body(url) do
		res = HTTPoison.get! url
		res.body
	end

	defp cache(links) do
		links
		|> Enum.each(fn link -> Cache |> Cache.put(link, %{crawl: true}) end)
		links
	end

	defp fix(links) do
		links
		|> Enum.map(fn str -> if str |> String.match?(~r/^\/(\w+|\d+)/), do: Cache.get("domain") <> str, else: str end)
	end

	defp peek(data) do
		IO.inspect data
		data
	end

	defp sanitize(links) do
		links
		|> Enum.filter(fn str -> str |> is_valid? end)
	end

	defp is_valid?(str) do
		if str |> String.length > 1 and not String.contains?(str, @notallowed) do
			true
		else 
			false
		end
	end
end