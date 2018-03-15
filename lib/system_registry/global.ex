defmodule SystemRegistry.Global do
  use GenServer

  alias SystemRegistry.Storage.State, as: S
  alias SystemRegistry.{Registration, Transaction, Processor}

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def put(scope, value) do
    GenServer.cast(__MODULE__, {:put, scope, value})
  end

  def apply_updates(pid, updates, nodes) do
    GenServer.cast(__MODULE__, {:update, pid, updates, nodes})
  end

  def apply_deletes(pid, deletes, nodes) do
    GenServer.cast(__MODULE__, {:delete, pid, deletes, nodes})
  end

  def init(_) do
    Registry.register(S, :global, %{})

    {:ok,
     %{
       monitors: []
     }}
  end

  def handle_cast({:put, scope, value}, s) do
    result =
      Registry.update_value(S, :global, fn r_value ->
        case scope do
          [_ | _] = scope -> update_in(r_value, scope, value)
          key -> Map.put(r_value, key, value)
        end
      end)

    notify(result)
    {:noreply, s}
  end

  def handle_cast({:update, pid, updates, nodes}, s) do
    result =
      Registry.update_value(S, :global, fn value ->
        Transaction.apply_bindings(pid, :global, updates, nodes)
        Transaction.apply_updates(value, updates)
      end)

    notify(result)
    {:noreply, monitor(pid, s)}
  end

  def handle_cast({:delete, pid, deletes, nodes}, s) do
    result =
      Registry.update_value(S, :global, fn value ->
        Transaction.remove_bindings(pid, :global, deletes, nodes)
        Transaction.apply_deletes(value, deletes, :global)
      end)

    notify(result)
    {:noreply, s}
  end

  def handle_info({:DOWN, _, _, pid, _}, s) do
    Registration.unregister_all(pid)

    Transaction.begin()
    |> Transaction.delete_all(pid, :global)
    |> Processor.Server.apply()

    s = demonitor(pid, s)
    {:noreply, s}
  end

  defp notify({unchanged, unchanged}), do: :noop

  defp notify({new, _old}) do
    Registration.notify(:global, new)
  end

  defp monitor(pid, s) do
    if Enum.any?(s.monitors, fn {m_pid, _ref} -> m_pid == pid end) do
      s
    else
      monitors = [{pid, Process.monitor(pid)} | s.monitors]
      %{s | monitors: monitors}
    end
  end

  defp demonitor(pid, s) do
    {[{_, ref}], monitors} = Enum.split_with(s.monitors, fn {m_pid, _} -> m_pid == pid end)
    Process.demonitor(ref)
    %{s | monitors: monitors}
  end
end
