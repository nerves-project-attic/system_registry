defmodule SystemRegistry.Registration do
  use GenServer

  alias SystemRegistry.Storage.Registration, as: R
  alias SystemRegistry.Storage.Binding, as: B
  alias SystemRegistry.Storage.State, as: S
  import SystemRegistry.Utils

  defstruct pid: nil, opts: [], key: nil, status: :ready, stale: false

  # Public API

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def registered?(pid \\ nil, key) do
    pid = pid || self()

    Registry.lookup(R, key)
    |> strip()
    |> Enum.any?(fn
      %{pid: reg} -> reg == pid
      _ -> false
    end)
  end

  def register(pid \\ nil, opts) do
    GenServer.call(__MODULE__, {:register, pid || self(), opts})
  end

  def unregister(pid \\ nil, key) do
    GenServer.call(__MODULE__, {:unregister, pid || self(), key})
  end

  def unregister_all(pid \\ nil) do
    GenServer.call(__MODULE__, {:unregister, pid || self()})
  end

  def notify(key, value) do
    GenServer.cast(__MODULE__, {:notify, key, value})
  end

  # GenServer API

  def init(args) do
    {:ok, args}
  end

  def handle_call({:register, pid, opts}, _, s) do
    key = opts[:key] || :global
    reply = Registry.lookup(S, key) |> strip()
    reg = %__MODULE__{pid: pid, opts: opts, key: key}
    Registry.register(R, key, [])
    Registry.update_value(R, key, &[reg | &1])

    Registry.register(B, pid, [])
    Registry.update_value(B, pid, &[reg | &1])
    notify_reg(reg, key, reply)
    {:reply, :ok, s}
  end

  def handle_call({:unregister, pid, key}, _, s) do
    Registry.update_value(R, key, fn value ->
      Enum.reject(value, fn %{pid: reg} -> reg == pid end)
    end)

    Registry.update_value(B, pid, fn value ->
      Enum.reject(value, fn %{key: reg} -> reg == key end)
    end)

    {:reply, :ok, s}
  end

  def handle_call({:unregister, pid}, _, s) do
    Registry.lookup(B, pid)
    |> strip()
    |> Enum.each(fn %{key: key} ->
      Registry.update_value(R, key, fn value ->
        Enum.reject(value, fn %{pid: reg} -> reg == pid end)
      end)
    end)

    Registry.unregister(B, pid)
    {:reply, :ok, s}
  end

  def handle_cast({:notify, key, value}, s) do
    Registry.update_value(R, key, fn registrants ->
      {limited, ready} =
        registrants
        |> Enum.split_with(&(&1.status != :ready))

      ready =
        Enum.map(ready, fn reg ->
          hysteresis(reg, key, value)
        end)

      limited = Enum.map(limited, &%{&1 | stale: true})
      ready ++ limited
    end)

    {:noreply, s}
  end

  def handle_info({:hysteresis_expired, %__MODULE__{} = reg}, s) do
    value = Registry.lookup(S, reg.key) |> strip()
    notify_reg(reg, reg.key, value)
    rate_limit(reg)

    Registry.update_value(R, reg.key, fn registrants ->
      {_reg, registrants} = Enum.split_with(registrants, &(&1.pid == reg.pid))
      [%{reg | status: :limited, stale: false} | registrants]
    end)

    {:noreply, s}
  end

  def handle_info({:min_interval_expired, %__MODULE__{} = reg}, s) do
    Registry.update_value(R, reg.key, fn registrants ->
      {reg, registrants} = Enum.split_with(registrants, &(&1.pid == reg.pid))

      case reg do
        [] ->
          registrants

        [reg] ->
          if reg.stale do
            value = Registry.lookup(S, reg.key) |> strip()
            notify_reg(reg, reg.key, value)
          end

          [%{reg | status: :ready, stale: false} | registrants]
      end
    end)

    {:noreply, s}
  end

  # Private

  defp hysteresis(%__MODULE__{} = reg, key, value) do
    hysteresis = reg.opts[:hysteresis] || 0

    case hysteresis do
      0 ->
        notify_reg(reg, key, value)
        rate_limit(reg)

      hysteresis ->
        Process.send_after(self(), {:hysteresis_expired, reg}, hysteresis)
        %{reg | status: :hysteresis, stale: true}
    end
  end

  defp rate_limit(%__MODULE__{} = reg) do
    min_interval = reg.opts[:min_interval] || 0

    case min_interval do
      0 ->
        reg

      interval ->
        Process.send_after(self(), {:min_interval_expired, reg}, interval)
        %{reg | status: :min_interval, stale: false}
    end
  end

  defp notify_reg(%__MODULE__{pid: pid}, key, value) do
    send(pid, {:system_registry, key, value})
  end
end
