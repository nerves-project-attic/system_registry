defmodule SystemRegistry.Registration do
  use GenServer

  alias SystemRegistry.Storage.Registration, as: R
  alias SystemRegistry.Storage.Binding, as: B
  alias SystemRegistry.Storage.State, as: S
  import SystemRegistry.Utils

  defstruct [pid: nil, opts: [], key: nil, limited: false, stale: false]

  # Public API

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def registered?(pid \\ nil, key) do
    pid = pid || self()
    Registry.lookup(R, key)
    |> strip()
    |> Enum.any?(fn
      (%{pid: reg}) -> reg == pid
      _ -> false
    end)
  end

  def register(pid \\ nil, key, opts) do
    GenServer.call(__MODULE__, {:register, (pid || self()), key, opts})
  end

  def unregister(pid \\ nil, key) do
    GenServer.call(__MODULE__, {:unregister, (pid || self()), key})
  end

  def unregister_all(pid \\ nil) do
    GenServer.call(__MODULE__, {:unregister, (pid || self())})
  end

  def notify(key, value) do
    GenServer.call(__MODULE__, {:notify, key, value})
  end

  # GenServer API

  def handle_call({:register, pid, key, opts}, _, s) do
    reply = Registry.lookup(S, key) |> strip()
    reg = %__MODULE__{pid: pid, opts: opts, key: key}
    Registry.register(R, key, [])
    Registry.update_value(R, key, &[reg | &1])

    Registry.register(B, pid, [])
    Registry.update_value(B, pid, &[reg | &1])
    {:reply, {:ok, reply}, s}
  end

  def handle_call({:unregister, pid, key}, _, s) do
    Registry.update_value(R, key, fn(value) ->
      Enum.reject(value, fn(%{pid: reg}) -> reg == pid end)
    end)
    Registry.update_value(B, pid, fn(value) ->
      Enum.reject(value, fn(%{key: reg}) -> reg == key end)
    end)
    {:reply, :ok, s}
  end

  def handle_call({:unregister, pid}, _, s) do
    Registry.lookup(B, pid)
    |> strip()
    |> Enum.each(fn(%{key: key}) ->
      Registry.update_value(R, key, fn(value) ->
        Enum.reject(value, fn(%{pid: reg}) -> reg == pid end)
      end)
    end)
    Registry.unregister(B, pid)
    {:reply, :ok, s}
  end

  def handle_call({:notify, key, value}, _, s) do
    Registry.update_value(R, key, fn(registrants)->
      {limited, available} =
        registrants
        |> Enum.split_with(& &1.limited)

      available =
        Enum.map(available, fn(reg) ->
          notify_reg(reg, key, value)
        end)

      limited =
        Enum.map(limited, & %{&1 | stale: true})
      available ++ limited
    end)
    {:reply, :ok, s}
  end

  def handle_info({:limit_expired, %__MODULE__{} = reg}, s) do
    Registry.update_value(R, reg.key, fn(registrants) ->
      {reg, registrants} =
        Enum.split_with(registrants, & &1.pid == reg.pid)

      case reg do
        [] -> registrants
        [reg] ->
          if reg.stale do
            value = Registry.lookup(S, reg.key) |> strip()
            notify_reg(reg, reg.key, value)
          end
          [%{reg | limited: false, stale: false} | registrants]
      end
    end)
    {:noreply, s}
  end

  # Private

  defp rate_limit(%__MODULE__{} = reg) do
    case reg.opts do
      0 -> reg
      _interval ->
        Process.send_after(self(), {:limit_expired, reg}, reg.opts)
        %{reg | limited: true, stale: false}
    end
  end

  defp notify_reg(%__MODULE__{pid: pid} = reg, key, value) do
    send(pid, {:system_registry, key, value})
    rate_limit(reg)
  end
end
