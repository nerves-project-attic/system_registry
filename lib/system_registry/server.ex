defmodule SystemRegistry.Server do
  @moduledoc false

  use GenServer

  alias SystemRegistry.Registration, as: R
  alias SystemRegistry.Binding, as: B
  alias SystemRegistry.State, as: S

  import SystemRegistry.Utils
  import SystemRegistry.Transaction

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

  def handle_call({:update, {:state, _, _} = scope, value}, {from, _ref}, s) do
    keys = Map.keys(value)
    {free, reserved} = ownership(scope, keys, from)
    case reserved do
      [] ->
        Process.monitor(from)
        apply_ownership(scope, free, from)
        {new, _old} = apply_update(scope, value)
        s = notify_all(from, new, s)
        {:reply, {:ok, new}, s}
      reserved ->
        {:reply, {:error, {:reserved_keys, reserved}}, s}
    end
  end

  def handle_call({:update, {:config, _, _} = scope, value}, {from, _ref}, s) do
    keys = Map.keys(value)
    {free, _reserved} = ownership(scope, keys, from)
    apply_ownership(scope, free, from)
    Process.monitor(from)
    {new, _old} = apply_update(scope, value)
    s = notify_all(from, new, s)
    {:reply, {:ok, new}, s}
  end

  def handle_call({:update, _, _}, {from, _ref}, s) do
    {:reply, {:error, :invalid_scope}, s}
  end

  def handle_call({:delete, scope, keys}, {from, _ref}, s) do
    {free, reserved} = ownership(scope, keys, from)
    case reserved do
      [] ->
        free_ownership(scope, keys, from)
        {new, _old} = apply_delete(scope, keys)
        s = notify_all(from, new, s)
        {:reply, {:ok, new}, s}
      reserved ->
        {:reply, {:error, {:reserved_keys, reserved}}, s}
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
          apply_delete(scope, [key])
          delete_set(scope, {pid, key})
        end)
    end
    Registry.unregister(R, pid)
    s = notify_all(pid, global(), s)
    {:noreply, s}
  end

  # Private API

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

end
