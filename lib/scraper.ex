defmodule Miner.Scraper do

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
		Task.Supervisor.start_child(Miner.TaskSupervisor, fn -> run(task) |> store end)
	end

	defp store(res) do
		
	end
end