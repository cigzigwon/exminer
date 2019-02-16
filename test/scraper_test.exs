defmodule Miner.ScraperTest do
  use ExUnit.Case, async: true
  doctest Miner.Scraper

  setup do
    tasks = Miner.TaskLoader.tasks("tasks.json")
    q = start_supervised!(Miner.TaskQueue)
  	Miner.TaskQueue.replace(q,  tasks)
    %{queue: q}
  end

  test "can fetch a url HTTPoison response" do
  	assert Miner.Scraper.fetch_url("https://www.google.com").status_code == 200
  	assert Miner.Scraper.fetch_url("https://google.com").status_code == 301
  end

  test "can process an item in the queue", %{queue: q} do
  	assert Miner.Scraper.run(Miner.TaskQueue.getAtIndex(q, 0)).status_code == 200
  end

  test "can process all items in queue and see results", %{queue: q} do
  	Miner.Scraper.process_queue(q)
    assert Miner.TaskQueue.getAtIndex(q, 0).url == "https://www.google.com"
    assert Miner.TaskQueue.getAtIndex(q, 1).status_code == 200
    assert Miner.TaskQueue.getAtIndex(q, 1).results == ["Basic types", "Booleans", "Tuples"]
  end
end