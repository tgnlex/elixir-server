defmodule Todo.Server do
  use GenServer, restart: :temporary
  def start_link(name) do
    IO.puts("Starting to-do server for #{name}")
  end

  defp via_tuple(name) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, name})
  end

  def handle_cast({:store, key, data}, state) do
    spawn(fn ->
      key
      |> file_name()
      |> File.write!(:erlang.term_to_binary(data))
    end)
    {:noreply, state}
  end
  def handle_call({:get, key}, caller, state) do
    spawn(fn ->
      data = case File.read(file_name(key)) do
        {:ok, contents} -> :erlang.binary_to_term(contents)
        _ -> nil
      end
      GenServer.reply(caller, data)
    end)
    {:noreply, state}
  end
  def handle_info(:real_init, state) do
    {:ok, {name. Todo.Database.get(name) || Todo.List.new()}}

  end
end
