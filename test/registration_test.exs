defmodule SystemRegistry.RegistrationTest do
  use ExUnit.Case, async: false

  alias SystemRegistry, as: SR
  alias SystemRegistry.Registration
  alias SystemRegistry.Storage.Binding, as: B

  setup ctx do
    flush(200)
    %{root: ctx.test}
  end

  test "registration returns current state", %{root: root} do
    scope = [:state, root, :a]
    value = 1
    SR.update(scope, value)
    :ok = SR.register(min_interval: 50)
    assert_receive {:system_registry, :global, state}
    assert ^value = get_in(state, scope)
  end

  test "can register and unregister" do
    SR.register()
    assert Registration.registered?(self(), :global)
    SR.unregister()
    refute Registration.registered?(self(), :global)
  end

  test "can unregister_all" do
    SR.register(key: :a, min_interval: 50)
    SR.register(key: :b, min_interval: 50)
    assert Registration.registered?(self(), :a)
    assert Registration.registered?(self(), :b)
    SR.unregister_all()
    refute Registration.registered?(self(), :a)
    refute Registration.registered?(self(), :b)
  end

  test "local notification delivery", %{root: root} do
    key = self()
    SR.register(key: key)
    update = %{root => %{a: 1}}
    SR.update([], update)
    assert_receive({:system_registry, ^key, ^update}, 10)
  end

  test "global notification delivery", %{root: root} do
    SR.register()
    SR.update([], %{state: %{root => %{a: 1}}})
    assert_receive({:system_registry, :global, %{state: %{^root => %{a: 1}}}}, 10)
  end

  test "rate limited notification delivery", %{root: root} do
    SR.register(min_interval: 50)
    SR.update([], %{state: %{root => %{a: 1}}})
    assert_receive({:system_registry, :global, %{state: %{^root => %{a: 1}}}}, 10)
    SR.update([], %{state: %{root => %{a: 2}}})
    refute_receive({:system_registry, :global, %{state: %{^root => %{a: 2}}}}, 10)
    assert_receive({:system_registry, :global, %{state: %{^root => %{a: 2}}}}, 80)
  end

  test "rate limit of 0 should dispatch every message", %{root: root} do
    SR.register()
    SR.update([], %{state: %{root => %{a: 1}}})
    assert_receive({:system_registry, :global, %{state: %{^root => %{a: 1}}}}, 10)
    SR.update([], %{state: %{root => %{a: 2}}})
    assert_receive({:system_registry, :global, %{state: %{^root => %{a: 2}}}}, 10)
  end

  test "hysteresis opts for rate limiting", %{root: root} do
    SR.register(hysteresis: 20, min_interval: 100)
    SR.update([], %{state: %{root => %{a: 1}}})
    refute_receive({:system_registry, :global, %{state: %{^root => %{a: 1}}}}, 10)
    assert_receive({:system_registry, :global, %{state: %{^root => %{a: 1}}}}, 20)
    SR.update([], %{state: %{root => %{a: 2}}})
    refute_receive({:system_registry, :global, %{state: %{^root => %{a: 2}}}}, 50)
    assert_receive({:system_registry, :global, %{state: %{^root => %{a: 2}}}}, 50)
  end

  test "notifications on update / delete", %{root: root} do
    SR.register()
    SR.update([:state, root, :a], 1)
    assert_receive({:system_registry, :global, %{state: %{^root => %{a: 1}}}}, 20)
    SR.delete([:state, root, :a])
    assert_receive({:system_registry, :global, %{}}, 20)
  end

  test "cannot convert an inner node into a leaf node", %{root: root} do
    update_task([:state, root, :a, :b], 1)
    SR.register()
    assert {:error, _} = SR.update([:state, root, :a], 1)
  end

  test "converting a inner node to a leaf should clean up bindings", %{root: root} do
    SR.update([:state, root, :a, :b], 1)
    SR.update([:state, root, :a], 1)

    reg =
      Registry.lookup(B, {:global, [:state, root, :a, :b]})
      |> SR.Utils.strip()

    assert reg == []
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

  def flush(ms) do
    receive do
      _ -> flush(ms)
    after
      ms -> :ok
    end
  end
end
