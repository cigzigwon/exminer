defmodule Miner do
  use Application

  def start(_type, _args) do
    Miner.Supervisor.start_link(name: Miner.Supervisor)
  end
end
