defmodule Miner.XPQTest do
  use ExUnit.Case, async: true
  doctest Miner.XPQ

  test "can query html doc for heading" do
  	assert Miner.XPQ.text("<html><body><h1>Elixir</h1><h1>v2</h1></body></html>", "h1") == "Elixirv2"
  end
end