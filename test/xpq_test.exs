defmodule Miner.XPQTest do
  use ExUnit.Case, async: true
  doctest Miner.XPQ

  test "can query html doc for heading" do
  	assert Miner.XPQ.getByTag("<html><body><h1>Elixir</h1></body></html>", "h1") == "Elixir"
  end
end