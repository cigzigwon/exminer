defmodule Miner.TaskQueue do
	use GenServer
	# the task queue must be a tub to build a list of web scraping tasks
	# 
	# {url: "", xquery: ""}...

	def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end
end