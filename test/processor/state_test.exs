defmodule SystemRegistry.Processor.StateTest do
  use ExUnit.Case
  alias SystemRegistry, as: SR

  setup ctx do
    %{root: ctx.test}
  end

  test "state processor updates global", %{root: root} do
    scope = [:state, root, :a]
    value = 1
    {:ok, _} = SR.update(scope, value)

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
    assert {:error, _} = SR.update([], update)
  end

  test "failed validation for deleting other owners keys", %{root: root} do
    update = %{state: %{root => %{a: 1}}}
    update_task([], update)
    assert {:error, _} = SR.delete([:state, root, :a])
  end

  test "owner can delete all from state", %{root: root} do
    SR.transaction()
    |> SR.update([:state, root, :a, :b], 1)
    |> SR.update([:state, root, :a, :c], 1)
    |> SR.commit()

    assert %{state: %{^root => %{a: %{b: 1, c: 1}}}} = SR.match(self(), %{state: %{root => %{}}})
    {:ok, _} = SR.delete_all()
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
