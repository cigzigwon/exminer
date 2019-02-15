defmodule Miner.ScraperTest do
  use ExUnit.Case, async: true
  doctest Miner.Scraper

  setup do
    q = start_supervised!(Miner.TaskQueue)
  	Miner.TaskQueue.add(q,  %{url: "https://www.google.com"})
  	Miner.TaskQueue.add(q,  %{
      url: "https://elixir-lang.org/getting-started/basic-types.html",
      xpq: %{get_by_tag: "h1"}
    })
    %{queue: q}
  end

  test "can fetch a url HTTPoison response" do
  	assert Miner.Scraper.fetch_url("https://www.google.com").status_code == 200
  	assert Miner.Scraper.fetch_url("https://google.com").status_code == 301
  end

  test "can process an item in the queue", %{queue: q} do
  	assert Miner.Scraper.run(Miner.TaskQueue.getAtIndex(q, 0)).status_code == 200
  end

  test "can process all items in queue", %{queue: q} do
  	assert Miner.Scraper.process_queue(q) == q
    assert Miner.TaskQueue.getAtIndex(q, 0).url == "https://www.google.com"
    assert Miner.TaskQueue.getAtIndex(q, 1).status_code == 200
    assert Miner.TaskQueue.getAtIndex(q, 1).result == "Basic types"
  end
end