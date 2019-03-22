defmodule Miner.CrawlerTest do
  use ExUnit.Case, async: true
  doctest Miner.Crawler

  @url "https://pyroclasti.cloud"

  # setup do

  # end

  test "can get all links from a page" do
  	assert is_list(Miner.Crawler.get(@url))
  end
end