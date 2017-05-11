  defmodule SystemRegistry.Processor.State do
  use SystemRegistry.Processor

  @mount :state

  alias SystemRegistry.Storage.Binding, as: B
  alias SystemRegistry.{Transaction, Global, Registration}

  def init(opts) do
    mount = opts[:mount] || @mount
    {:ok, %{mount: mount, opts: opts}}
  end

  def handle_validate(%Transaction{} = t, s) do
    pid = t.pid
    mount = s.mount
    update_nodes = filter_nodes(t.update_nodes, mount)
    delete_nodes = filter_nodes(t.delete_nodes, mount)


    {_, _, reserved} =
      (update_nodes ++ delete_nodes)
      |> Enum.reduce({[], [], []}, fn(n, {free, owner, reserved}) ->
        case Registry.lookup(B, {:global, n.node}) do
          [] -> {[n.node | free], owner, reserved}
          [{_, %{from: nil}}] -> {[n.node | free], owner, reserved}
          [{_, %{from: ^pid}}] -> {free, [n.node | owner], reserved}
          _ -> {free, owner, [n.node | reserved]}
        end
      end)
    case reserved do
      [] -> {:ok, :ok, s}
      r -> {:error, {__MODULE__, {:reserved_keys, r}}, s}
    end
  end

  def handle_commit(%Transaction{} = t, s) do
    mount = s.mount
    update_nodes = filter_nodes(t.update_nodes, mount)
    delete_nodes = filter_nodes(t.delete_nodes, mount)
    updates = Map.get(t.updates, mount)
    deletes = Enum.filter(t.deletes, fn
      [^mount | _] -> true
      _ -> false
    end)

    modified? =
      apply_updates(updates, update_nodes, mount) or apply_deletes(deletes, delete_nodes)

    if modified? do
      global = SystemRegistry.match(:global, :_)
      Registration.notify(:global, global)
    end
    {:ok, {:ok, modified?}, s}
  end

  def apply_updates(nil, _, _), do: false
  def apply_updates(updates, nodes, mount) do
    updates = Map.put(%{}, mount, updates)
    case Global.apply_updates(updates, nodes) do
      {_, _} -> true
      _error -> false
    end
  end

  def apply_deletes([], _), do: false
  def apply_deletes(deletes, nodes) do
    case Global.apply_deletes(deletes, nodes) do
      {:ok, _} -> true
      _error -> false
    end
  end

  def filter_nodes(nodes, mount) do
    Enum.filter(nodes, fn(node) ->
      case node.node do
        [^mount | _] -> true
        _ -> false
      end
    end)
  end
end
