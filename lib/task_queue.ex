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

	def getAtIndex(queue, index) do
		Agent.get(queue, fn state -> try do elem(state, index) rescue _e in ArgumentError -> nil end end)
	end

	def update(queue, index, item) do
		Agent.update(queue, fn state -> put_elem(state, index, item) end)
	end
end