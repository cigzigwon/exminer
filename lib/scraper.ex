defmodule Miner.Scraper do
	require Logger

	def fetch_url(url) do
		HTTPoison.start
		HTTPoison.get! url
	end

	def process_queue(q) do
		task = Task.Supervisor.async(Miner.TaskQueueSupervisor, fn -> task_reducer(q) end)
		Task.await(task)
		q
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

	defp handle_result(res, q, index, task) do
		try do
			results = []
			results = Enum.map(task.xpq, fn query -> results ++ Miner.XPQ.get(res.body, query.selector) end)
			Miner.TaskQueue.update(q, index, %{url: task.url, xpq: task.xpq, results: results, status_code: res.status_code})
		rescue
			e in KeyError -> e
		end

		index + 1
	end

	defp task_reducer(q) do
		Enum.reduce(Miner.TaskQueue.get(q) |> Tuple.to_list, 0, fn task, index -> spawn_task(task) |> handle_result(q, index, task) end)
	end
end