defmodule SystemRegistry.NodeTest do
  use ExUnit.Case, async: true

  alias SystemRegistry.Node

  setup ctx do
    %{root: ctx.test}
  end

  test "Node Structures" do
    assert [:a] == Node.parent([:a, :b])
    assert %Node{parent: [:a], node: [:a, :b], from: self(), key: :b} ==
      Node.leaf([:a, :b])

    assert [%Node{parent: [], node: [:a], from: nil, key: :a}] ==
      Node.inodes([:a, :b])
  end

  test "leaf nodes" do
    assert [[:a, :b], [:a, :c, :d]] == Node.leaf_nodes(%{a: %{b: 1, c: %{d: 2}}})
  end

end
