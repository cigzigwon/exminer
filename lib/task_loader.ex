defmodule Miner.TaskLoader do
	def tasks(path) do
		path
		|> load_file
		|> parse_json
		|> List.to_tuple
	end

	defp load_file(path) do
		path |> File.read!
	end

	defp parse_json(json) do
		json |> Poison.decode!(%{keys: :atoms!})
	end
end