defmodule Miner.Crawler.CacheTest do
  use ExUnit.Case, async: true
  doctest Miner.Crawler.Cache
  alias Miner.Crawler.Cache

  @range 1..10

  setup do
    cache = start_supervised!(Miner.Crawler.Cache)
    %{cache: cache}
  end

  test "an empty cache is supervised" do
  	assert Cache.get("key") == nil
  end

  test "a cache can be written to and read from", %{cache: cache} do
  	assert Cache.put(cache, "key", "value") == :ok
  	assert {:ok, value} = Cache.get("key")
  	assert value == "value"
  end

  test "the cache can get blasted with key vals", %{cache: cache} do
  	for _ <- @range do
  		assert Cache.put(cache, "key", "value") == :ok
  	end

  	assert list = Cache.get("key")
  	assert Enum.count(list) == 10
  end
end