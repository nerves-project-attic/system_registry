defmodule SystemRegistryTest do
  use ExUnit.Case, async: true
  doctest SystemRegistry

  setup config do
    %{key: config.test}
  end

  test "Registration returns current state" do
    global = SystemRegistry.match(:_)
    assert {:ok, ^global} = SystemRegistry.register()
  end

  test "owner can change values", %{key: key} do
    assert {:ok, %{state: %{a: %{^key => %{a: 1}}}}} =
      SystemRegistry.transaction({:state, :a, key}, %{a: 1})
    assert {:ok, %{state: %{a: %{^key => %{a: 2}}}}} =
      SystemRegistry.transaction({:state, :a, key}, %{a: 2})
  end

  test "ownership of keys and lifecycle", %{key: key} do
    {_, task} = transaction_task({:state, :a, key}, %{a: 1})
    assert {:error, {:reserved_keys, [:a]}} =
      SystemRegistry.transaction({:state, :a, key}, %{a: 2})
    SystemRegistry.register(100)
    Process.exit(task, :kill)
    assert_receive {:system_registry, %{state: %{a: %{^key => %{}}}}}, 50
  end

  test "receive rate limited", %{key: key} do
    SystemRegistry.register(250)
    SystemRegistry.transaction({:state, :a, key}, %{a: 1})
    refute_receive {:system_registry, %{state: %{a: %{^key => %{a: 1}}}}}, 300
    transaction_task({:state, :a, key}, %{b: 2})
    assert_receive {:system_registry, %{state: %{a: %{^key => %{a: 1, b: 2}}}}}, 50
    transaction_task({:state, :a, key}, %{c: 3})
    refute_receive {:system_registry, %{state: %{a: %{^key => %{a: 1, b: 2, c: 3}}}}}, 50
    assert_receive {:system_registry, %{state: %{a: %{^key => %{a: 1, b: 2, c: 3}}}}}, 250
  end

  defp transaction_task(scope, value) do
    parent = self()
    {:ok, task} =
      Task.start(fn ->
        send(parent, SystemRegistry.transaction(scope, value))
        Process.sleep(:infinity)
      end)
    assert_receive {:ok, global}
    {global, task}
  end

end
