defmodule SystemRegistry.Processor.StateTest do
  use SystemRegistryTest.Case
  alias SystemRegistry, as: SR

  @sleep 20

  setup ctx do
    %{root: ctx.test}
  end

  test "state processor updates global", %{root: root} do
    scope = [:state, root, :a]
    value = 1
    {:ok, _} = SR.update(scope, value)
    :timer.sleep(@sleep)

    assert ^value =
             SR.match(:global, :_)
             |> get_in(scope)

    assert ^value =
             SR.match(self(), :_)
             |> get_in(scope)
  end

  test "failed validation for updating other owners keys", %{root: root} do
    update = %{state: %{root => %{a: 1}}}
    update_task([], update)

    t =
      SR.transaction(notify_on_error: true)
      |> SR.update([], update)

    SR.commit(t)
    :timer.sleep(@sleep)
    assert_receive({:system_registry, :transaction_failed, {^t, _}})
  end

  test "failed validation for deleting other owners keys", %{root: root} do
    update = %{state: %{root => %{a: 1}}}
    update_task([], update)

    t =
      SR.transaction(notify_on_error: true)
      |> SR.delete([:state, root, :a])

    SR.commit(t)
    :timer.sleep(@sleep)
    assert_receive({:system_registry, :transaction_failed, {^t, _}})
  end

  test "owner can delete all from state", %{root: root} do
    SR.transaction()
    |> SR.update([:state, root, :a, :b], 1)
    |> SR.update([:state, root, :a, :c], 1)
    |> SR.commit()

    :timer.sleep(@sleep)
    assert %{state: %{^root => %{a: %{b: 1, c: 1}}}} = SR.match(self(), %{state: %{root => %{}}})
    {:ok, _} = SR.delete_all()
    :timer.sleep(@sleep)
    value = SR.match(:_)
    assert get_in(value, [:state, root]) == nil
  end

  defp update_task(scope, value) do
    parent = self()

    {:ok, task} =
      Task.start(fn ->
        send(parent, SR.update(scope, value))
        Process.sleep(:infinity)
      end)
    
    assert_receive {:ok, delta}
    {delta, task}
  end
end
