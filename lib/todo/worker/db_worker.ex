defmodule Todo.DatabaseWorker do
  use GenServer
  def start_link({db_folder, worker_id}) do
    IO.puts("Starting database worker #{worker_id}")

    GenServer.start_link(
      __MODULE__,
      db_folder,
      name: via_tuple(worker_id)
    )
  end

  def store(worker_id, key, data) do
    GenServer.cast(via_tuple(worker_id), {:store, key, data})
  end
  def get(worker_id, key) do
    GenServer.call(via_tuple(worker_id), {:get, key})
  end
  defp via_tuple(worker_id) do
    Todo.ProcessRegistry.via_tuple({__MODULE, worker_id})
  end
end
