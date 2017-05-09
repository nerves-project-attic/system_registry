defmodule SystemRegistryTest do
  use ExUnit.Case, async: true
  doctest SystemRegistry

  alias SystemRegistry, as: SR
  alias SystemRegistry.Node

  setup ctx do
    %{root: ctx.test}
  end

  test "maps are transformed into composed transactions", %{root: root} do
    t =
      SR.transaction()
      |> SR.update([root], %{b: 1, c: 2})

    parent = %Node{parent: [], node: [root], from: nil, key: root}
    leaf_b = %Node{parent: [root], node: [root, :b], from: self(), key: :b}
    leaf_c = %Node{parent: [root], node: [root, :c], from: self(), key: :c}

    assert MapSet.member?(t.nodes, parent)
    assert MapSet.member?(t.nodes, leaf_b)
    assert MapSet.member?(t.nodes, leaf_c)

    assert t.updates == %{root => %{b: 1, c: 2}}
  end

  test "local transaction commit", %{root: root} do
    update = %{root => %{a: 1}}
    SR.update([], update)
    assert ^update = SR.match(self(), update)

    SR.delete([root, :a])
    assert %{} == SR.match(self(), :_)
  end

  test "match specs", %{root: root} do
    update = %{root => %{a: 1}}
    SR.update([], update)
    assert ^update = SR.match(self(), update)
    assert %{} == SR.match(self(), %{blah: %{}})
  end

  test "can delete all nodes for a process", %{root: root} do
    SR.transaction
    |> SR.update([root, :a, :b], 1)
    |> SR.update([root, :a, :c], 1)
    |> SR.commit

    assert %{^root => %{a: %{b: 1, c: 1}}} = SR.match(self(), %{root => %{}})
    SR.delete_all()
    value = SR.match(self(), :_)
    assert Map.get(value, root) == %{}
  end


end
