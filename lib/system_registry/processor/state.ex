defmodule SystemRegistry.Processor.State do
  use SystemRegistry.Processor

  @mount :state

  alias SystemRegistry.{Transaction, Global, Node}

  import SystemRegistry.Processor.Utils

  def init(opts) do
    mount = opts[:mount] || @mount
    {:ok, %{mount: mount, opts: opts}}
  end

  def handle_validate(%Transaction{} = t, s) do
    mount = s.mount
    update_nodes = filter_nodes(t.update_nodes, mount)
    delete_nodes = filter_nodes(t.delete_nodes, mount)

    update_reserved = permissions(update_nodes, t.pid)
    delete_reserved = permissions(delete_nodes, t.pid)

    global = SystemRegistry.Utils.global()

    leaf_reserved =
      Node.leaf_nodes(t.updates)
      |> Enum.reduce([], fn scope, reserved ->
        case get_in(global, scope) do
          nil ->
            reserved

          map ->
            frag_reserved =
              Transaction.scope(scope, map)
              |> Node.leaf_nodes()
              |> Enum.map(&%Node{node: &1})
              |> permissions(t.pid)

            if frag_reserved == [] do
              reserved
            else
              [scope | reserved]
            end
        end
      end)

    case update_reserved ++ delete_reserved ++ leaf_reserved do
      [] -> {:ok, :ok, s}
      r -> {:error, {__MODULE__, {:reserved_keys, r}}, s}
    end
  end

  def handle_commit(%Transaction{} = t, s) do
    mount = s.mount
    {update_nodes, updates} = updates(t, s.mount)
    {delete_nodes, deletes} = deletes(t, s.mount)

    apply_deletes(t.pid, deletes, delete_nodes)
    apply_updates(t.pid, updates, update_nodes, mount)

    {:ok, :ok, s}
  end

  def apply_updates(_, nil, _, _), do: false

  def apply_updates(pid, updates, nodes, mount) do
    updates = Map.put(%{}, mount, updates)
    Global.apply_updates(pid, updates, nodes)
  end

  def apply_deletes(_, [], []), do: false

  def apply_deletes(pid, deletes, nodes) do
    Global.apply_deletes(pid, deletes, nodes)
  end

  def permissions(nodes, pid) do
    Enum.reduce(nodes, [], fn n, reserved ->
      case Node.binding(:global, n.node) do
        %{from: nil} ->
          reserved

        %{from: f_pid} when f_pid != pid ->
          [n.node | reserved]

        _ ->
          reserved
      end
    end)
  end
end
