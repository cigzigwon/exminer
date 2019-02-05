defmodule Miner.TaskQueue do
	# is a queueue of tasks
	# {%{url: "", xquery: ""}, %{url: "", xquery: ""}, %{url: "", xquery: ""}}

	def start_link() do
		Agent.start_link(fn -> {} end)
	end

	def add(queue, task) do
		Agent.update(queue, &Tuple.append(&1, task))
	end

	def get(queue) do
		Agent.get(queue, fn state -> state end)
	end

	def getAtIndex(queue, index) do
		Agent.get(queue, fn state -> try do elem(state, index) rescue _e in ArgumentError -> nil end end)
	end

	def replace(queue, tasks) do
		Agent.update(queue, fn _state -> tasks end)
	end

	def update(queue, index, task) do
		Agent.update(queue, fn state -> put_elem(state, index, task) end)
	end
end