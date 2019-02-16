defmodule Miner.ScraperTest do
  use ExUnit.Case, async: true
  doctest Miner.Scraper

  setup do
    Miner.TaskLoader.tasks("tasks.json") |> Miner.Scraper.build_queue
  end

  test "can fetch a url HTTPoison response" do
  	assert Miner.Scraper.fetch_url("https://www.google.com").status_code == 200
  	assert Miner.Scraper.fetch_url("https://google.com").status_code == 301
  end

  test "can process an item in the queue" do
  	assert Miner.Scraper.run(Miner.TaskQueue.getAtIndex(Miner.TaskQueue, 0)).status_code == 200
  end

  test "can process all items in queue and see results" do
  	assert Miner.Scraper.process_queue == 2
    assert Miner.TaskQueue.getAtIndex(Miner.TaskQueue, 0).url == "https://www.google.com"
    assert Miner.TaskQueue.getAtIndex(Miner.TaskQueue, 1).status_code == 200
    assert Miner.TaskQueue.getAtIndex(Miner.TaskQueue, 1).results == ["Basic types", "Booleans", "Tuples"]
  end
end