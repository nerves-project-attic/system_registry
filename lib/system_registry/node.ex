defmodule SystemRegistry.Node do
  defstruct parent: [], node: [], key: nil, from: nil

  @type t :: [
          parent: SystemRegistry.scope(),
          node: SystemRegistry.scope(),
          key: any(),
          from: pid | nil
        ]

  alias SystemRegistry.Storage.Binding, as: B
  alias SystemRegistry.Transaction

  import SystemRegistry.Utils

  def binding(key, scope) do
    Registry.lookup(B, {key, scope}) |> strip()
  end

  def parent(node) do
    [_l | internal_nodes] = Enum.reverse(node)
    Enum.reverse(internal_nodes)
  end

  def is_leaf?(%__MODULE__{from: nil}), do: false
  def is_leaf?(%__MODULE__{}), do: true

  @spec leaf(SystemRegistry.scope(), pid()) :: t()
  def leaf(node, pid) do
    [l | internal_nodes] = Enum.reverse(node)
    parent = Enum.reverse(internal_nodes)
    %__MODULE__{parent: parent, node: node, key: l, from: pid}
  end

  @doc """
  Return the leaf nodes in full path form.

  ## Examples

    iex> SystemRegistry.Node.leaf_nodes(%{a: 2})
    [[:a]]

    iex> SystemRegistry.Node.leaf_nodes(%{a: %{b: 1, c: %{d: 2}}})
    [[:a, :b], [:a, :c, :d]]

    iex> SystemRegistry.Node.leaf_nodes(%{})
    []
  """
  @spec leaf_nodes(map()) :: [SystemRegistry.scope()]
  def leaf_nodes(map) do
    leaf_nodes([], map)
  end

  defp leaf_nodes(pred, map) when not is_map(map) do
    [Enum.reverse(pred)]
  end

  defp leaf_nodes(pred, map) do
    Enum.flat_map(map, fn {k, v} -> leaf_nodes([k | pred], v) end)
  end

  @spec trim_tree(any(), SystemRegistry.scope(), any()) :: any()
  def trim_tree(value, [], _), do: value

  def trim_tree(value, [key | t] = path, bind_key) when is_map(value) do
    case get_in(value, path) do
      map when map == %{} ->
        case t do
          [] ->
            Map.delete(value, key)

          _ ->
            [key | u_path] = Enum.reverse(path)
            u_path = Enum.reverse(u_path)
            Transaction.remove_binding(bind_key, path)

            update_in(value, u_path, &Map.delete(&1, key))
            |> trim_tree(u_path, bind_key)
        end

      _ ->
        value
    end
  end

  @spec internal_nodes(SystemRegistry.scope()) :: [t()]
  def internal_nodes(node) do
    node
    |> Enum.reverse()
    |> tl()
    |> internal_node()
  end

  @spec internal_node(SystemRegistry.scope(), [t()]) :: [t()]
  defp internal_node(_, _ \\ [])
  defp internal_node([], internal_nodes), do: internal_nodes

  defp internal_node([key | path], internal_nodes) do
    parent = Enum.reverse(path)
    internal_node = %__MODULE__{parent: parent, node: parent ++ [key], key: key}
    internal_node(path, [internal_node | internal_nodes])
  end
end
