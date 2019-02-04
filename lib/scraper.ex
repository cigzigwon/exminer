defmodule Miner.Scraper do

	def get(url) do
		HTTPoison.start
		HTTPoison.get! url
	end
end