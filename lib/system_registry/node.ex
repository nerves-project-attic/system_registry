defmodule SystemRegistry.Node do
  defstruct parent: [], node: [], key: nil, from: nil

  @type t :: [
          parent: [term],
          node: [term],
          key: term,
          from: pid | nil
        ]

  alias SystemRegistry.Storage.Binding, as: B
  alias SystemRegistry.Transaction

  import SystemRegistry.Utils

  def binding(key, scope) do
    case Registry.lookup(B, {key, scope}) do
      [] -> nil
      binding -> strip(binding)
    end
  end

  def parent(node) do
    [_l | inodes] = Enum.reverse(node)
    Enum.reverse(inodes)
  end

  def is_leaf?(%__MODULE__{from: nil}), do: false
  def is_leaf?(%__MODULE__{}), do: true

  def leaf(node, opts \\ []) do
    pid = opts[:pid] || self()
    [l | inodes] = Enum.reverse(node)
    parent = Enum.reverse(inodes)
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
  def leaf_nodes(map) do
    leaf_nodes([], map)
  end

  defp leaf_nodes(pred, map) when not is_map(map) do
    [Enum.reverse(pred)]
  end

  defp leaf_nodes(pred, map) do
    Enum.flat_map(map, fn {k, v} -> leaf_nodes([k | pred], v) end)
  end

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

  def inodes(node) do
    node
    |> Enum.reverse()
    |> tl()
    |> inode()
  end

  defp inode(_, _ \\ [])
  defp inode([], inodes), do: inodes

  defp inode([key | path], inodes) do
    parent = Enum.reverse(path)
    inode = %__MODULE__{parent: parent, node: parent ++ [key], key: key}
    inode(path, [inode | inodes])
  end
end
