defmodule Todo.Database do
  use GenServer
  @pool_size 3
  @db_folder = "./persist"

  def start_link() do
    File.mkdir_p!(@db_folder)
    children = Enum.map(1..@pool_size, &worker_spec/1)
    Supervisor.start_link(children, startegy: one_for_one)
  end
  defp worker_spec(worker_id) do
    default_worker_spec = [Todo.DatabaseWorekr, [@db_folder, worker_id]]
    Supervisor.child_spec(default_worker_spec, id: worker_id)
  end
  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end
  def store(key, data) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.store(key, data)
  end
  def get(key, data) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.get(key)
  end
  defp choose_worker(key) do
    :erlang.phash2(key, @pool_size) + 1
  end
  def init() do
    File.mkdir_p! (@db_folder)
    {:ok, nil}
  end
  def handle_cast({:store, key, data}, state) do
    key
    |> file_name()
    |> File.write!(:erlang.term_to_binary(data))
    {:noreply, state}
  end

  def handle_call({:get, key}, _, state) do
    data = case File.read(file_name(key)) do
      {:ok, contents} -> :erlang.binary_to_term(contents)
      _ -> nil
    end
    {:reply, data, state}
  end
  defp file_name(key) do
    Path.join(@db_folder, to_string(key))
  end
end
