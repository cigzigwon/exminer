defmodule Miner.TaskQueue do
	# is a queueue of tasks
	# is a multi element tuple of maps
	# {%{url: "", xquery: ""}, %{url: "", xquery: ""}, %{url: "", xquery: ""}}

	def start_link() do
		Agent.start_link(fn -> {} end)
	end

	def add(queue, item) do
		Agent.update(queue, &Tuple.append(&1, item))
	end

	def get(queue) do
		Agent.get(queue, fn state -> state end)
	end
end