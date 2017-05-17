defmodule SystemRegistry.Transaction do
  @moduledoc false
  defstruct [pid: nil, key: nil, opts: [],
    delete_nodes: nil, update_nodes: nil, updates: [], deletes: []]

  alias SystemRegistry.Node
  alias SystemRegistry.Storage.State, as: S
  alias SystemRegistry.Storage.Binding, as: B

  import SystemRegistry.Utils

  @type t :: %__MODULE__{
    pid: pid,
    key: term,
    opts: keyword(),
    update_nodes: MapSet.t,
    delete_nodes: MapSet.t,
    updates:  map,
    deletes:  MapSet.t
  }

  def begin(opts \\ []) do
    %__MODULE__{
      pid: self(),
      key: self(),
      opts: opts,
      updates: %{},
      deletes: MapSet.new,
      update_nodes: MapSet.new,
      delete_nodes: MapSet.new}
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
      |> Enum.reduce(t.update_nodes, &MapSet.put(&2, &1))
    scope_map = scope(scope, value)
    updates = deep_merge(scope_map, t.updates)
    %{t |
      update_nodes: nodes,
      updates: updates}
  end

  def move(%__MODULE__{} = t, old_scope, new_scope) do
    node = Registry.lookup(B, {t.pid, old_scope}) |> strip
    current_value =
      Registry.match(S, t.key, :_)
      |> strip
    new_value = get_in(current_value, old_scope)
    
    t
    |> delete(old_scope)
    |> update(new_scope, new_value)
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
      delete_nodes: MapSet.put(t.delete_nodes, leaf),
      deletes: MapSet.put(t.deletes, leaf)}
  end

  def prepare(%__MODULE__{} = t) do
    t
    |> prepare_deletes()
    |> prepare_delete_nodes()
  end

  def commit(%__MODULE__{} = t) do
    Registry.register(S, t.key, %{})
    delta =
      Registry.update_value(S, t.key, fn(value) ->
        value
        |> apply_deletes(t.deletes, t.key)
        |> apply_updates(t.updates)
      end)
    case delta do
      :error -> {:error, :update_local}
      delta ->
        remove_bindings(t.key, t.delete_nodes)
        apply_bindings(t.key, t.update_nodes)
        {:ok, delta}
    end
  end

  def apply_bindings(key, nodes) do
    Enum.map(nodes, &Registry.register(B, {key, &1.node}, &1))
  end

  def remove_bindings(key, nodes) do
    Enum.map(nodes, &remove_binding(key, &1.node))
  end

  def remove_binding(key, path) do
    Registry.unregister(B, {key, path})
  end

  def apply_updates(value, updates) do
    deep_merge(value, updates)
  end

  def apply_deletes(value, deletes, bind_key) do
    Enum.reduce(deletes, value, fn
      (%Node{parent: [], key: key}, value) ->
        remove_binding(bind_key, [key])
        Map.delete(value, key)
      (%Node{parent: path, key: key}, value) ->
        update_in(value, path, &Map.delete(&1, key))
        |> Node.trim_tree(path, bind_key)
    end)
  end

  def scope(scope, value) do
    scope
    |> Enum.reverse
    |> Enum.reduce(value, &Map.put(%{}, &1, &2))
  end

  defp prepare_delete_nodes(t) do
    local = Registry.lookup(S, t.pid) |> strip()
    prune =
      Node.leaf_nodes(t.updates)
      |> Enum.reduce([], fn(scope, deletes) ->
        case get_in(local, scope) do
          nil -> deletes
          map ->
            scopes =
              scope(scope, map)
              |> Node.leaf_nodes()
            deletes ++ scopes
        end
      end)
    Enum.map(prune, & Node.leaf(&1, pid: t.pid))
    |> Enum.reduce(t, fn(node, t) ->
      %{t | delete_nodes: MapSet.put(t.delete_nodes, node)}
    end)
  end

  defp prepare_deletes(%__MODULE__{pid: pid} = t) do
    {delete_nodes, deletes} =
      Enum.reduce(t.deletes, {t.delete_nodes, MapSet.new}, fn(node, {delete_nodes, deletes}) ->
        reg_node = Registry.lookup(B, {t.key, node.node}) |> strip()
        cond do
          reg_node == [] -> {delete_nodes, MapSet.put(deletes, node)}
          Node.is_leaf?(reg_node) -> {delete_nodes, MapSet.put(deletes, node)}
          true ->
            scope = scope(node.node, %{})
            scope = Registry.match(S, t.key, scope) |> strip()
            leaf_nodes =
              Node.leaf_nodes(scope)
              |> Enum.reduce(MapSet.new, fn
                (scope, acc) ->
                  node = Registry.lookup(B, {pid, scope}) |> strip()
                  case node do
                    (%{from: ^pid}) -> MapSet.put(deletes, node)
                    _ -> acc
                  end
              end)
            {MapSet.union(delete_nodes, leaf_nodes), MapSet.union(deletes, leaf_nodes)}
        end
      end)
    %{t | delete_nodes: delete_nodes, deletes: deletes}
  end

end
