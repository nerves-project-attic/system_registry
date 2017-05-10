defmodule SystemRegistry.Transaction do
  @moduledoc false
  defstruct [pid: nil, nodes: [], updates: [], deletes: []]

  alias SystemRegistry.Node
  alias SystemRegistry.Storage.State, as: S
  alias SystemRegistry.Storage.Binding, as: B

  import SystemRegistry.Utils

  @type t :: %__MODULE__{
    pid: pid,
    nodes: MapSet.t,
    updates:  map,
    deletes:  MapSet.t
  }

  def begin do
    %__MODULE__{updates: %{}, deletes: MapSet.new, pid: self(), nodes: MapSet.new}
  end

  # Add an update to a transaction
  def update(%__MODULE__{} = t, scope, value) when is_map(value) do
    Enum.reduce(value, t, fn({k, v}, t) ->
      update(t, (scope ++ [k]), v)
    end)
  end

  def update(%__MODULE__{} = t, scope, value) do
    leaf = Node.leaf(scope)
    inodes = Node.inodes(scope)
    nodes =
      [leaf | inodes]
      |> Enum.reduce(t.nodes, &MapSet.put(&2, &1))
    scope_map = scope(scope, value)
    updates = deep_merge(scope_map, t.updates)
    %{t |
      nodes: nodes,
      updates: updates}
  end

  def delete(%__MODULE__{} = t, value) when is_map(value) do
    Node.leaf_nodes(value)
    |> Enum.reduce(t, fn(node, t) ->
      delete(t, node)
    end)
  end

  def delete(%__MODULE__{} = t, scope) do
    leaf = Node.leaf(scope)
    %{t |
      nodes: MapSet.put(t.nodes, leaf),
      deletes: MapSet.put(t.deletes, leaf)}
  end

  def commit(%__MODULE__{} = t) do
    Registry.register(S, t.pid, %{})
    delta =
      Registry.update_value(S, t.pid, fn(value) ->
        value
        |> apply_updates(t.updates)
        |> apply_deletes(t.deletes)
      end)
    case delta do
      :error -> {:error, :update_local}
      delta ->
        apply_bindings(t.nodes)
        {:ok, delta}
    end
  end

  def apply_bindings(nodes) do
    Enum.map(nodes, &Registry.register(B, &1.node, &1))
  end

  def apply_updates(value, updates) do
    deep_merge(value, updates)
  end

  def apply_deletes(value, deletes) do
    Enum.reduce(deletes, value, fn(%Node{parent: path, key: key}, value) ->
      update_in(value, path, &Map.delete(&1, key))
      |> Node.trim_tree(path)
    end)
  end

  defp scope(scope, value) do
    scope
    |> Enum.reverse
    |> Enum.reduce(value, &Map.put(%{}, &1, &2))
  end

end
