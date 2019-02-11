defmodule Miner.Scraper do
	require Logger
	require IO

	def fetch_url(url) do
		HTTPoison.start
		HTTPoison.get! url
	end

	def process_queue(tasks) do
		Enum.each(Tuple.to_list(tasks), fn task -> spawn_task(task) end)
	end

	def run(task) do
			task.url
			|> fetch_url
	end

	defp spawn_task(task) do
		task = Task.Supervisor.async_nolink(Miner.TaskSupervisor, fn -> run(task) |> store end)
		Task.await(task) |> IO.inspect
	end

	defp store(res) do
		"Status: #{res.status_code}" |> Logger.info
	end
end