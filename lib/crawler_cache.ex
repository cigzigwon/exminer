defmodule Miner.Crawler.Cache do
	use GenServer

	@name :cache

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def get(key) do
  	case :ets.lookup(@name, key) do
      [{^key, value}] -> {:ok, value}
      [] -> nil
    end
  end

  def put(cache, key, value) do
  	GenServer.call(cache, {:put, key, value})
  end

  ## Callbacks

  @impl true
  def init(_) do
  	table = :ets.new(@name, [:set, :protected, :named_table, read_concurrency: true])
    {:ok, table}
  end

  @impl true
  def handle_call({:put, key, value}, _from, table) do
  	:ets.insert(table, {key, value})
    {:reply, :ok, table}
  end
end