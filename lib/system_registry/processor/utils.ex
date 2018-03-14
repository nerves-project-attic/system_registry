defmodule SystemRegistry.Processor.Utils do
  def filter_nodes(nodes, mount) do
    Enum.filter(nodes, fn node ->
      case node.node do
        [^mount | _] -> true
        _ -> false
      end
    end)
  end

  def updates(t, mount) do
    nodes = filter_nodes(t.update_nodes, mount)
    updates = Map.get(t.updates, mount)
    {nodes, updates}
  end

  def deletes(t, mount) do
    nodes = filter_nodes(t.delete_nodes, mount)

    deletes =
      Enum.filter(t.deletes, fn
        %{node: [^mount | _]} -> true
        _ -> false
      end)

    {nodes, deletes}
  end

  @spec modified?(updates :: {[Node.t()], map}, deletes :: {[Node.t()], [Node.t()]}) ::
          true | false
  def modified?({_, updates}, {_, deletes})
      when updates == nil and deletes == [],
      do: false

  def modified?(_, _), do: true
end
