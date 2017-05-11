defmodule SystemRegistry.Processor.ConfigTest do
  use ExUnit.Case, async: false

  alias SystemRegistry, as: SR

  Application.put_env(:system_registry, SystemRegistry.Processor.Config,
    priorities: [
      :pa,
      :pb,
      :pc
    ])

  setup ctx do
    %{root: ctx.test}
  end

  test "config processor updates global", %{root: root} do
    assert {:ok, _} = SR.update(:pa, [:config, root, :a], 1)
    assert %{config: %{^root => %{a: 1}}} = SR.match(%{config: %{root => %{}}})
  end

  test "config processor orders by priority global", %{root: root} do
    assert {:ok, _} = SR.update(:pc, [:config, root, :a], 1)
    assert %{config: %{^root => %{a: 1}}} = SR.match(%{config: %{root => %{}}})
    assert {:ok, _} = SR.update(:pb, [:config, root, :a], 2)
    assert %{config: %{^root => %{a: 2}}} = SR.match(%{config: %{root => %{}}})
    assert {:ok, _} = SR.update(:pa, [:config, root, :b], 3)
    assert %{config: %{^root => %{a: 2, b: 3}}} = SR.match(%{config: %{root => %{}}})
  end

  test "config is recalculated when a producer dies", %{root: root} do
    {_, task} = update_task(:pa, [:config, root, :a], 1)
    assert %{config: %{^root => %{a: 1}}} = SR.match(%{config: %{root => %{}}})
    Process.exit(task, :kill)
  end

  test "return error is transaction tag is not in priorities", %{root: root} do
    assert {:error, _} = SR.update(:pd, [:config, root, :a], 1)
  end

  defp update_task(key, scope, value) do
    parent = self()
    {:ok, task} =
      Task.start(fn ->
        send(parent, SR.update(key, scope, value))
        Process.sleep(:infinity)
      end)
    assert_receive {:ok, delta}
    {delta, task}
  end

end
