defmodule MinerTest do
  use ExUnit.Case
  doctest Miner

  test "greets the world" do
    assert Miner.hello() == :world
  end
end
