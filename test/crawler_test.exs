defmodule CrawlerTest do
  use ExUnit.Case

  test "can weild a non-broken pipeline to get a list of links from any domain" do
  	links = Miner.Crawler.fetch("https://pyroclasti.cloud/", %{init: "https://pyroclasti.cloud/"})
    assert 2 == length(links)
  end
end