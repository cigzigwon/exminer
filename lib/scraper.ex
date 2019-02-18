defmodule Miner.Scraper do
	require Logger

	def fetch_url(url) do
		HTTPoison.get! url
	end

	def build_queue(tasks) do
		Miner.TaskQueue.replace(Miner.TaskQueue, tasks)
	end

	def process_queue() do
		task = Task.Supervisor.async(Miner.TaskQueueSupervisor, fn -> task_reducer() end)
		Task.await(task)
	end

	def run(task) do
			task.url
			|> fetch_url
	end

	defp spawn_task(task) do
		task = Task.Supervisor.async_nolink(Miner.TaskSupervisor, fn -> run(task) |> log end)
		Task.await(task)
	end

	defp log(res) do
		"response status: #{res.status_code}" |> Logger.info
		res
	end

	defp handle_result(res, index, task) do
		try do
			results = []
			results = Enum.map(task.xpq, fn query -> results ++ Miner.XPQ.get(res.body, query.selector) end)
			Miner.TaskQueue.update(Miner.TaskQueue, index, %{url: task.url, xpq: task.xpq, results: results, status_code: res.status_code})
		rescue
			e in KeyError -> e
		end

		index + 1
	end

	defp task_reducer() do
		Enum.reduce(Miner.TaskQueue.get(Miner.TaskQueue) |> Tuple.to_list, 0, fn task, index -> spawn_task(task) |> handle_result(index, task) end)
	end
end