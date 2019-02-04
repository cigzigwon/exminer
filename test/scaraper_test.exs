defmodule Miner.ScraperTest do
  use ExUnit.Case, async: true
  doctest Miner.Scraper

  test "can fetch a url HTTPoison response" do
  	assert Miner.Scraper.get("https://www.google.com").status_code == 200
  	assert Miner.Scraper.get("https://google.com").status_code == 301
  end
end