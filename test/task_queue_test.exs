defmodule Miner.TaskQueueTest do
  use ExUnit.Case
  doctest Miner.TaskQueue

  test "has tuple list of tasks in struct" do
  	q = %Miner.TaskQueue{}
    assert q.tasks == {}
  end
end
