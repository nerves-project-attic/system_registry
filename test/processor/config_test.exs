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
    assert {:ok, _} = SR.update([:config, root, :a], 1, priority: :pa)
    assert %{config: %{^root => %{a: 1}}} = SR.match(%{config: %{root => %{}}})
  end

  test "config processor orders by priority global", %{root: root} do
    assert {:ok, _} = SR.update([:config, root, :a], 1, priority: :pc)
    assert %{config: %{^root => %{a: 1}}} = SR.match(%{config: %{root => %{}}})
    assert {:ok, _} = SR.update([:config, root, :a], 2, priority: :pb)
    assert %{config: %{^root => %{a: 2}}} = SR.match(%{config: %{root => %{}}})
    assert {:ok, _} = SR.update([:config, root, :b], 3, priority: :pa)
    assert %{config: %{^root => %{a: 2, b: 3}}} = SR.match(%{config: %{root => %{}}})
  end

  test "config is recalculated when a producer dies", %{root: root} do
    {_, task} = update_task([:config, root, :a], 1, priority: :pa)
    assert %{config: %{^root => %{a: 1}}} = SR.match(%{config: %{root => %{}}})
    Process.exit(task, :kill)
  end

  test "return error if transaction priority is not declared in application configuration", %{root: root} do
    assert {:error, _} = SR.update([:config, root, :a], 1, priority: :pd)
  end

  test "allow default priorities", %{root: root} do
    Application.put_env(:system_registry, SystemRegistry.Processor.Config,
      priorities: [
        :pa,
        :_,
        :pc
      ])
      assert {:ok, _} = SR.update([:config, root, :a], 1, priority: :pc)
      assert %{config: %{^root => %{a: 1}}} = SR.match(%{config: %{root => %{}}})
      assert {:ok, _} = SR.update([:config, root, :a], 2, priority: :pb)
      assert %{config: %{^root => %{a: 2}}} = SR.match(%{config: %{root => %{}}})
      assert {:ok, _} = SR.update([:config, root, :a], 3, priority: :pa)
      assert {:ok, _} = SR.update([:config, root, :b], 4, priority: :pa)
      assert %{config: %{^root => %{a: 3, b: 4}}} = SR.match(%{config: %{root => %{}}})
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
