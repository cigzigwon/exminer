defmodule Miner.Crawler do
	require Logger

	@valid_http ["http://", "https://"]

	def crawl(domain) do
		domain
		|> fetch_body
		|> Floki.find("a")
		|> Floki.attribute("href")
		|> Enum.map(fn(url) -> fetch_body(url) end)

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

	defp log(str) do
		Logger.info str
		str
	end
end