defmodule Miner.Crawler do
	alias Miner.Crawler.Cache
	require IO

	@valid_http ["http://", "https://"]
	@not_allowed ["mailto:", "tel:"]

	def get(url) do
		url
		|> fetch_body
		|> refs
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

	defp inspect(data) do
		IO.inspect data
		data
	end
end