defmodule Miner.Crawler do
	alias Miner.Crawler.Cache
	require Logger

	@valid_http ["http://", "https://"]
	@not_allowed ["mailto:", "tel:"]

	def cache(list, domain) do
		Cache |> Cache.put(domain, list)
	end

	def crawl(domain) do
		domain
		|> fetch_body
		|> Floki.find("a")
		|> Floki.attribute("href")
		|> filter
		|> cache(domain)
	end

	defp fetch_body(url) do
		if String.contains?(url, @valid_http) do
			log url
			res = HTTPoison.get! url
			res.body
		else
			""
		end
	end

	defp log(str) do
		Logger.info str
		str
	end

	defp filter(list) do
		list |>
		Enum.map(fn (href) -> 
			if not String.contains?(href, @not_allowed) and String.length(href) > 1 do
				href
			end
		end)
	end
end