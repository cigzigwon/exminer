defmodule Miner.ScraperTest do
  use ExUnit.Case, async: true
  doctest Miner.Scraper

  setup do
    {:ok, q} = Miner.TaskQueue.start_link([])
    item = %{url: "https://www.google.com", xdq: ""}
  	Miner.TaskQueue.add(q, item)
  	Miner.TaskQueue.add(q, item)
    %{queue: q}
  end

  test "can fetch a url HTTPoison response" do
  	assert Miner.Scraper.fetch_url("https://www.google.com").status_code == 200
  	assert Miner.Scraper.fetch_url("https://google.com").status_code == 301
  end

  test "can process an item in the queue", %{queue: q} do
  	assert Miner.Scraper.process(Miner.TaskQueue.getAtIndex(q, 0)).status_code == 200
  end

  test "can process all items in queue", %{queue: q} do
  	assert Miner.Scraper.process_queue(Miner.TaskQueue.get(q)) == :ok
  end
end