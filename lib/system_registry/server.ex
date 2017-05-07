defmodule SystemRegistry.Server do
  use GenServer

  alias SystemRegistry.Registration, as: R
  alias SystemRegistry.Binding, as: B
  alias SystemRegistry.State, as: S
  import SystemRegistry.Utils

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [opts], name: __MODULE__)
  end

  # GenServer API

  def init(_opts) do
    Registry.register(S, :global, %{})
    {:ok, %{
      rate_limited: []
    }}
  end

  def handle_call({:transaction, scope, value}, {from, _ref}, s) do
    keys = Map.keys(value)
    case ownership(scope, keys, from) do
      {:ok, free} ->
        Process.monitor(from)
        apply_ownership(scope, free, from)
        {new, _old} = apply_transaction(scope, value)
        s = notify_all(from, new, s)
        {:reply, {:ok, new}, s}
      error ->
        {:reply, error, s}
    end
  end

  def handle_call({:register, interval}, {from, _ref}, s) do
    Registry.register(R, from, interval)
    {:reply, {:ok, global()}, s}
  end

  def handle_call({:unregister}, {from, _ref}, s) do
    {:reply, Registry.unregister(R, from), s}
  end

  def handle_info({:rate_limit_expired, pid}, s) do
    {rl, rate_limited} =
      Enum.split_with(s.rate_limited, fn({rl_pid, _}) -> rl_pid == pid end)
    case List.first(rl) do
      {_, true} ->
        notify(pid, global())
      _ -> :noop
    end
    {:noreply, %{s | rate_limited: rate_limited}}
  end

  # A linked process died, clean up registrations and state
  def handle_info({:DOWN, _, _, pid, _}, s) do
    case Registry.lookup(B, pid) do
      [] ->
        :noop
      records ->
        set = strip(records) |> List.first
        Enum.each(set, fn({scope, key}) ->
          Registry.update_value(S, :global, fn(global) ->
            scope = Tuple.to_list(scope)
            update_in(global, scope, &Map.delete(&1, key))
          end)
          delete_set(scope, {pid, key})
        end)
    end
    Registry.unregister(R, pid)
    s = notify_all(pid, global(), s)
    {:noreply, s}
  end

  # Private API

  defp ownership(scope, keys, pid) do
    scope_set =
      Registry.lookup(B, scope)
      |> strip
      |> List.first

    {free, reserved} =
      case scope_set do
        nil -> {keys, []}
        scope_set ->
          Enum.reduce(keys, {[], []}, fn(key, {free, reserved}) ->
            value = Enum.find(scope_set, fn
              ({_, ^key}) -> true
              _ -> false
            end)

            case value do
              nil -> {[key | free], reserved}
              {^pid, _} -> {free, reserved}
              _ -> {free, [key | reserved]}
            end
          end)
      end

    case reserved do
      [] -> {:ok, free}
      reserved ->
        {:error, {:reserved_keys, reserved}}
    end
  end

  defp apply_ownership(scope, keys, owner) do
    put_set(scope, Enum.map(keys, &({owner, &1})))
    put_set(owner, Enum.map(keys, &({scope, &1})))
  end

  defp apply_transaction(scope, value) do
    scope = scope_map(scope, value)
    Registry.update_value(S, :global, &deep_merge(&1, scope))
  end

  defp notify_all(from, msg, s) do
    {_rate_limited, registrations} =
      Registry.keys(R, self())
      |> Enum.split_with(fn(pid) ->
        Enum.any?(s.rate_limited, fn({rl_pid, _}) -> rl_pid == pid end)
        or pid == from
      end)

    registrations =
      registrations
      |> Enum.map(fn(pid) ->
        [{_, value}] = Registry.lookup(R, pid)
        {pid, value}
      end)

    Enum.each(registrations, fn({pid, opts}) ->
      notify(pid, msg)
      rate_limit(pid, opts)
    end)

    old_rl =
      Enum.map(s.rate_limited, fn
        {pid, false} -> {pid, true}
        rl -> rl
      end)

    new_rl =
      Enum.map(registrations, fn({pid, _}) ->
        {pid, false}
      end)
    %{s | rate_limited: old_rl ++ new_rl}
  end

  defp notify(pid, msg) do
    send(pid, {:system_registry, msg})
  end

  defp rate_limit(pid, interval) do
    Process.send_after(self(), {:rate_limit_expired, pid}, interval)
  end

  defp put_set(key, values) when is_list(values) do
    Registry.register(B, key, MapSet.new())
    Registry.update_value(B, key, fn(current) ->
      Enum.reduce(values, current, &MapSet.put(&2, &1))
    end)
  end

  defp put_set(key, value) do
    Registry.register(B, key, MapSet.new())
    Registry.update_value(B, key, &MapSet.put(&1, value))
  end

  defp delete_set(key, values) when is_list(values) do
    Registry.update_value(B, key, fn(current) ->
      Enum.reduce(values, current, &MapSet.delete(&2, &1))
    end)
  end

  defp delete_set(key, value) do
    Registry.update_value(B, key, &MapSet.delete(&1, value))
  end

  defp scope_map(scope, value) do
    scope
    |> Tuple.to_list()
    |> Enum.reverse
    |> Enum.reduce(value, &Map.put(%{}, &1, &2))
  end

end
