defmodule Miner.TaskQueueTest do
  use ExUnit.Case, async: true
  doctest Miner.TaskQueue

  setup do
    item = %{url: "https://www.google.com", xdq: ""}
    q = start_supervised!(Miner.TaskQueue)
    Miner.TaskQueue.add(q, item)
    %{queue: q}
  end

  test "can add tasks to the queue", %{queue: q} do
  	assert Miner.TaskQueue.get(q) == {item}
  end

  test "can get a task by index", %{queue: q} do
  	assert Miner.TaskQueue.getAtIndex(q, 0) == item
  	assert Miner.TaskQueue.getAtIndex(q, 1) == nil
  end

  test "can get a newly added task", %{queue: q} do
    Miner.TaskQueue.add(q, item)
    assert Miner.TaskQueue.getAtIndex(q, 1) == item
  end

  test "can update a task with response data", %{queue: q} do
    item = Map.put(item, :resp, "<html></html>")
    Miner.TaskQueue.update(q, 0, item)
    assert Miner.TaskQueue.getAtIndex(q, 0).resp == item.resp
  end

  test "can replace existing state", %{queue: q} do
    tasks = {%{url: "https://www.google.com", xdq: ""}, %{url: "https://www.stawars.com", xdq: ""}}
    Miner.TaskQueue.replace(q, tasks)
    assert Miner.TaskQueue.get(q) == tasks
  end
end
