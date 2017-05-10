  defmodule SystemRegistry.Processor.State do
  use SystemRegistry.Processor

  @mount :state

  alias SystemRegistry.Storage.Binding, as: B
  alias SystemRegistry.{Transaction, Global, Registration}

  def init(opts) do
    {:ok, %{opts: opts}}
  end

  def handle_validate(%Transaction{} = t, s) do
    pid = t.pid
    {_, _, reserved} =
      Enum.reduce(t.nodes, {[], [], []}, fn(n, {free, owner, reserved}) ->
        Registry.lookup(B, n.node)
        case Registry.lookup(B, n.node) do
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
    mount = s.opts[:mount] || @mount
    updates = Map.get(t.updates, mount)
    deletes = Enum.filter(t.deletes, fn
      [^mount | _] -> true
      _ -> false
    end)

    modified? =
      apply_updates(updates, mount) or apply_deletes(deletes)

    if modified? do
      global = SystemRegistry.match(:global, :_)
      Registration.notify(:global, global)
    end
    {:ok, {:ok, modified?}, s}
  end

  def apply_updates(nil, _), do: false
  def apply_updates(updates, mount) do
    updates = Map.put(%{}, mount, updates)
    case Global.apply_updates(updates) do
      {_, _} -> true
      _error -> false
    end
  end

  def apply_deletes([]), do: false
  def apply_deletes(deletes) do
    case Global.apply_deletes(deletes) do
      {:ok, _} -> true
      _error -> false
    end
  end
end
