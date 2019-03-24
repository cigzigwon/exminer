defmodule Miner.Crawler do
	alias Miner.Crawler.Cache
	require IO

	@notallowed ["mailto:", "tel:", "ftp:", "#", "javascript:", "@"]

	def get(url) do
		if Cache.get("domain") == nil do
			Cache |> Cache.put("domain", url)
		end
	
		url
		|> parse_url
		|> fetch_body
		|> refs
		|> fix
		|> sanitize
		|> cache
		|> write
		|> crawl
	end

	defp crawl(links) do
		links
		|> Enum.each(fn link ->
			if Cache.get(link).crawl and link |> String.contains?(Cache.get("domain")) do
				Cache |> Cache.put(link, %{crawl: false})
				write(link)
				get(link)
			end
		end)
		links
	end

	defp parse_url(url) do
		url
		|> URI.parse
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

	defp peek(data) do
		IO.inspect data
		data
	end

	defp sanitize(links) do
		links
		|> Enum.filter(fn url -> url |> is_valid? end)
	end

	defp is_valid?(url) do
		if url |> String.length > 1 and not String.contains?(url, @notallowed) do
			true
		else 
			false
		end
	end

	defp write(links) do
		{:ok, file} = File.open("dump.json", [:write])
    IO.binwrite(file, links |> Poison.encode!)
    File.close(file)
    links
	end
end