defmodule Miner.TaskLoaderTest do
  use ExUnit.Case, async: true
  doctest Miner.TaskLoader

  setup do
  	path = "tasks.json"
  	%{path: path}
  end

  test "returns a tuple of tasks", %{path: path} do
  	assert is_tuple(Miner.TaskLoader.tasks(path))
  end
end