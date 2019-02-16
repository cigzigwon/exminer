defmodule Miner.TaskLoaderTest do
  use ExUnit.Case, async: true
  doctest Miner.TaskLoader

  setup do
  	path = "tasks.json"
  	%{path: path}
  end

  test "returns a map of tasks", %{path: path} do
  	assert Miner.TaskLoader.tasks(path) ==  {
              %{url: "https://www.google.com"},
              %{
                url: "https://elixir-lang.org/getting-started/basic-types.html",
                xpq: [
                  %{selector: "h1"},
                  %{selector: "#booleans"},
                  %{selector: "#tuples"}
                ]
              }
            }
  end
end