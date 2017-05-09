defmodule SystemRegistry.Node do
  defstruct [parent: [], node: [], key: nil, from: nil]

  @type t :: [
    parent: [term],
    node: [term],
    key: term,
    from: pid | nil
  ]

  def parent(node) do
    [l | inodes] = Enum.reverse(node)
    parent = Enum.reverse(inodes)
  end

  def leaf(node) do
    [l | inodes] = Enum.reverse(node)
    parent = Enum.reverse(inodes)
    %__MODULE__{parent: parent, node: node, key: l, from: self()}
  end

  # If someone knows how to handle this better, please, do!
  def leaf_nodes(map, _ \\ []) do
      {:ok, agent} = Agent.start_link(fn -> [] end)
      leaf_nodes(map, [], agent)
      value =
        Agent.get(agent, & &1)
        |> Enum.reverse
      Agent.stop(agent)
      value
  end
  def leaf_nodes(map, path, agent) when is_map(map) do
    Enum.reduce(map, [], fn
      ({k, v}, acc) -> [leaf_nodes(v, [k | path], agent) | acc]
    end)
  end
  def leaf_nodes(_value, path, agent) do
    path =  Enum.reverse(path)
    Agent.update(agent, &[path | &1])
  end

  def trim_tree(value, []), do: value
  def trim_tree(value, [key | t] = path) when is_map(value) do
    case get_in(value, path) do
      map when map == %{} ->
        case t do
          [] ->
            Map.delete(value, key)
          _ ->
            [key | path] = Enum.reverse(path)
            path = Enum.reverse(path)
            update_in(value, path, &Map.delete(&1, key))
            |> trim_tree(t)
        end
      _ -> value
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
