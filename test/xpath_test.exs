defmodule Miner.XPathTest do
  use ExUnit.Case, async: true
  doctest Miner.XPath

  test "can query html doc for heading" do
  	assert Miner.XPath.query("<html><body><h1>Elixir</h1></body></html>") == 'Elixir'
  end
end