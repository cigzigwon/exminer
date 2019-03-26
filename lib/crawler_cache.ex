defmodule Miner.Crawler.Cache do
	use GenServer

	@name :cache

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def flush(cache) do
    GenServer.call(cache, :flush)
  end

  def get(key) do
  	case :ets.lookup(@name, key) do
      [{^key, value}] -> value
      [] -> nil
    end
  end

  def dump() do
    :ets.tab2list(@name)
  end

  def put(cache, key, value) do
  	GenServer.call(cache, {:put, key, value})
  end

  def write() do
    links = dump() |> transform
    {:ok, file} = File.open("dump.json", [:write])
    IO.binwrite(file, links |> Poison.encode!(pretty: true))
    File.close(file)
  end

  defp transform(list) do
    list |> Enum.map(fn {k, _v} -> %{url: k, xpq: []} end)
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

  @impl true
  def handle_call(:flush, _from, table) do
    :ets.delete_all_objects(table)
    {:reply, :ok, table}
  end
end