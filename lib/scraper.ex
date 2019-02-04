defmodule Miner.Scraper do

	def fetch_url(url) do
		HTTPoison.start
		HTTPoison.get! url
	end
end