defmodule Miner.Crawler.CacheTest do
  use ExUnit.Case, async: true
  doctest Miner.Crawler.Cache
  alias Miner.Crawler.Cache

  @range 1..10

  setup do
    cache = Cache
    %{cache: cache}
  end

  test "an empty cache is supervised", %{cache: cache} do
    Cache.flush(cache)
  	assert Cache.get("key") == nil
  end

  test "a cache can be written to and read from", %{cache: cache} do
    Cache.flush(cache)
  	assert Cache.put(cache, "key", "value") == :ok
  	assert Cache.get("key") == "value"
  end

  test "the cache can get blasted with key vals", %{cache: cache} do
    Cache.flush(cache)
  	for _ <- @range do
  		assert Cache.put(cache, "key", "value") == :ok
  	end

  	assert Cache.get("key") == "value"
  end 

  test "cannot be overwritten if key exists", %{cache: cache} do
    Cache.flush(cache)
    assert Cache.put(cache, "key", "value") == :ok
    assert Cache.put(cache, "key", "newval") == :ok
    assert Cache.get("key") == "newval"
  end

  test "can dump cache", %{cache: cache} do
    Cache.flush(cache)
    assert Cache.put(cache, "key", "value") == :ok
    assert Cache.dump == [{"key", "value"}]
  end

  test "can write cache to file" , %{cache: cache} do
    Cache.flush(cache)
    assert Cache.put(cache, "key", "value") == :ok
    assert Cache.write == :ok
  end
end