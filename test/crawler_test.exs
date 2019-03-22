defmodule Miner.CrawlerTest do
  use ExUnit.Case, async: true
  doctest Miner.Crawler

  @url "https://pyroclasti.cloud"

  setup do
  	links = Miner.Crawler.get(@url)
  	%{links: links}
  end

  test "can get all links from a page", %{links: links} do
  	assert is_list(links)
  end

  test "can sanitize list of links of non-urls", %{links: links} do
  	assert links == ["http://brewcruzr.com", "https://github.com/cigzigwon/exminer",
			"https://pyroclasti.cloud/blog",
			"https://phoenixframework.org/"]
  end

  test "can get a link from cache" do
  	assert {:ok, links} = Miner.Crawler.Cache.get(@url)
  	assert is_list(links)
  	assert links |> List.first == "http://brewcruzr.com"
  end

  test "can crawl a given domain after getting initial links in cache" do
  	assert Miner.Crawler.crawl(@url) == :ok
  	assert {:ok, links} = Miner.Crawler.Cache.get("https://pyroclasti.cloud/blog")
  	assert is_list(links)
  	assert links == []
  end
end