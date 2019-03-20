defmodule Miner.Crawler.CacheTest do
  use ExUnit.Case, async: true
  doctest Miner.Crawler.Cache
  alias Miner.Crawler.Cache

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
end