defmodule Todo.System do
  def start_link do
    Supervisor.start_link(
      [
        Todo.ProcessRegistry,
        Todo.Database,
        Todo.Cache
      ],
      strategy: :one_for_one
    )
  end
  def init(_) do
    Supervisor.init([Todo.Cache, Todo.Database, Todo.ProcessRegistry], strategy: :one_for_one)
  end
end
