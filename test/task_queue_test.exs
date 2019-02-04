defmodule Miner.TaskQueueTest do
  use ExUnit.Case, async: true
  doctest Miner.TaskQueue

  setup do
    {:ok, q} = Miner.TaskQueue.start_link
    %{queue: q}
  end

  test "can add tasks to the queue", %{queue: q} do
  	item = %{url: "https://google.com", xdq: ""}
  	Miner.TaskQueue.add(q, item)
  	assert Miner.TaskQueue.get(q) == {item}
  end
end
