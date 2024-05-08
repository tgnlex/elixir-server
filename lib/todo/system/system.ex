defmodule Todo.System do
  def start_link do
    Supervisor.start_link(
      [
        Todo.Task.Metrics,
        Todo.ProcessRegistry,
        Todo.Database,
        Todo.Cache
      ],
      strategy: :one_for_one
    )
  end
  def init(_) do
    Supervisor.init([Todo.Cache, Todo.Database, Todo.ProcessRegistry, Todo.Task.Metrics], strategy: :one_for_one)
  end
end
