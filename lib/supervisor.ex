defmodule Miner.Supervisor do
  # Automatically defines child_spec/1
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      {Miner.TaskQueue, name: Miner.TaskQueue},
      {Task.Supervisor, name: Miner.TaskSupervisor},
      {Task.Supervisor, name: Miner.TaskQueueSupervisor}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end