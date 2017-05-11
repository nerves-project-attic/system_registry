defmodule SystemRegistry.RegistrationTest do
  use ExUnit.Case, async: true

  alias SystemRegistry, as: SR
  alias SystemRegistry.Registration

  setup ctx do
    %{root: ctx.test}
  end

  test "registration returns current state", %{root: root} do
    scope = [:state, root, :a]
    value = 1
    SR.update(:test, scope, value)
    {:ok, state} = SR.register(:global, 50)
    assert ^value = get_in(state, scope)
  end

  test "can register and unregister" do
    SR.register(:global, 50)
    assert Registration.registered?(self(), :global)
    SR.unregister(:global)
    refute Registration.registered?(self(), :global)
  end

  test "can unregister_all" do
    SR.register(:a, 50)
    SR.register(:b, 50)
    assert Registration.registered?(self(), :a)
    assert Registration.registered?(self(), :b)
    SR.unregister_all()
    refute Registration.registered?(self(), :a)
    refute Registration.registered?(self(), :b)
  end

  test "local notification delivery", %{root: root} do
    key = self()
    SR.register(key, 50)
    update = %{root => %{a: 1}}
    SR.update(:test, [], update)
    assert_received({:system_registry, ^key, ^update})
  end

  test "global notification delivery", %{root: root} do
    SR.register(50)
    SR.update(:test, [],  %{state: %{root => %{a: 1}}})
    assert_receive({:system_registry, :global, %{state: %{^root => %{a: 1}}}}, 10)
  end

  test "rate limited notification delivery", %{root: root} do
    SR.register(50)
    SR.update(:test, [],  %{state: %{root => %{a: 1}}})
    assert_receive({:system_registry, :global, %{state: %{^root => %{a: 1}}}}, 10)
    SR.update(:test, [],  %{state: %{root => %{a: 2}}})
    refute_receive({:system_registry, :global, %{state: %{^root => %{a: 2}}}}, 10)
    assert_receive({:system_registry, :global, %{state: %{^root => %{a: 2}}}}, 50)
  end

  test "rate limit of 0 should dispatch every message", %{root: root} do
    SR.register(0)
    SR.update(:test, [],  %{state: %{root => %{a: 1}}})
    assert_received({:system_registry, :global, %{state: %{^root => %{a: 1}}}})
    SR.update(:test, [],  %{state: %{root => %{a: 2}}})
    assert_received({:system_registry, :global, %{state: %{^root => %{a: 2}}}})
  end

end
