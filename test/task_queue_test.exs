defmodule Miner.TaskQueueTest do
  use ExUnit.Case, async: true
  doctest Miner.TaskQueue

  setup do
    {:ok, q} = Miner.TaskQueue.start_link
    %{queue: q}
  end

  test "can add tasks to the queue", %{queue: q} do
  	item = %{url: "https://www.google.com", xdq: ""}
  	Miner.TaskQueue.add(q, item)

  	assert Miner.TaskQueue.get(q) == {item}
  end

  test "can get a task by index", %{queue: q} do
  	item = %{url: "https://www.google.com", xdq: ""}
  	Miner.TaskQueue.add(q, item)

  	assert Miner.TaskQueue.getAtIndex(q, 0) == item
  	assert Miner.TaskQueue.getAtIndex(q, 1) == nil

  	Miner.TaskQueue.add(q, item)

  	assert Miner.TaskQueue.getAtIndex(q, 1) == item
  end

  test "can update a task with response data", %{queue: q} do
    item = %{url: "https://www.google.com", xdq: ""}
    Miner.TaskQueue.add(q, item)
    item = Map.put(item, :resp, "<html></html>")
    Miner.TaskQueue.update(q, 0, item)

    assert Miner.TaskQueue.getAtIndex(q, 0).resp == item.resp
  end
end
