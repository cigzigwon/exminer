defmodule Miner.CrawlerTest do
  use ExUnit.Case
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
  	assert {:ok, state} = Miner.Crawler.Cache.get("https://pyroclasti.cloud/blog")
  	assert state == %{crawl: true}
  end
end