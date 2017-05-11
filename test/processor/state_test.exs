defmodule SystemRegistry.Processor.StateTest do
  use ExUnit.Case, async: true

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
