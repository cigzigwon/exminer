defmodule Miner.Crawler do
	require Logger

	@valid_http ["http://", "https://"]
	@not_allowed ["mailto:", "tel:"]

	def crawl(domain) do
		domain
		|> fetch_body
		|> Floki.find("a")
		|> Floki.attribute("href")
		|> Enum.map(fn (url) -> fetch_body(domain, url |> validate) end)

		:ok
	end

	defp fetch_body(url) do
		log url
		if String.contains?(url, @valid_http) do
			res = HTTPoison.get! url
			res.body
		else
			""
		end
	end

	defp fetch_body(domain, url) do
		url =
		if not String.contains?(url, @valid_http) and String.length(url) > 1 do
			domain <> url
		else
			url
		end

		if String.contains?(url, domain) do
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

	defp validate(href) do
		if String.contains?(href, @not_allowed) do
			""
		else
			href
		end
	end
end