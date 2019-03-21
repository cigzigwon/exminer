defmodule Miner.CrawlerTest do
  use ExUnit.Case, async: true
  doctest Miner.Crawler

  @domain "https://pyroclasti.cloud"

  # setup do

  # end

  test "can crawl links on the domain" do
  	assert Miner.Crawler.crawl(@domain) == :ok
  end
end