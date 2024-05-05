defmodule Todo do
  use GenServer
  @moduledoc """
  Documentation for `Todo`.
  """
  @doc """
  Hello world.
  """

  def init(_) do
    {:ok, %{}}
  end
  def handle_call({:server_process, todo_list_name}, _,  todo_servers) do
    case Map.fetch(todo_servers, todo_list_name) do
      {:ok, todo_server} ->
        {:reply, todo_server, todo_servers,}
        end
  end
end
