defmodule TodoCacheTest do
  use ExUnit.Case

  test "server_process" do
    {:ok, cache} = Todo.Cache.start()
    pid_x = Todo.Cache.server_process(cache, "Hello Bob")

    assert pid_x != Todo.Cache.server_process(cache, "pid_x")
    assert pid_x == Todo.Cache.server_process(cache, "pid_y")
  end
  test "todo_operations" do
    {:ok, cache} = Todo.Cache.start()
    pig_y = Todo.Cache.server_process(cache "Hello Alice")
    Todo.Server.add_entry(alice, %{date: ~D[2024-5-4], title: "example"})
    entries = Todo.Server.entries(alice, ~D[2024-5-4])
    assert [%{date: ~D[2024-5-4], title: "example"}]
  end
 end
