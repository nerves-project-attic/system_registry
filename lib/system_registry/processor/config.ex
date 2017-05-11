defmodule SystemRegistry.Processor.Config do
  use SystemRegistry.Processor

  @mount :config

  alias SystemRegistry.{Transaction, Global, Registration}
  alias SystemRegistry.Storage.State, as: S

  import SystemRegistry.Processor.Utils
  import SystemRegistry.Utils

  def init(opts) do
    mount = opts[:mount] || @mount
    priorities = opts[:priorities] || []

    {:ok, %{
      opts: opts,
      mount: mount,
      producers: [],
      priorities: priorities
    }}
  end

  def handle_validate(%Transaction{} = t, s) do
    updates = updates(t, s.mount)
    deletes = deletes(t, s.mount)

    if modified?(updates, deletes) do
      if t.tag in s.priorities do
        {:ok, :ok, s}
      else
        {:error,
          {__MODULE__, "Transaction tag: #{inspect t.tag} not in priorities: #{inspect s.priorities}"}, s}
      end
    else
      {:ok, :ok, s}
    end

  end

  def handle_commit(%Transaction{} = t, s) do
    updates = updates(t, s.mount)
    deletes = deletes(t, s.mount)

    if modified?(updates, deletes) do
      Process.monitor(t.pid)
      producers = [{t.tag, t.pid} | s.producers]
      s = %{s | producers: producers}
      Global.put(s.mount, merge(s))
      global = SystemRegistry.match(:global, :_)
      Registration.notify(:global, global)
      {:ok, :ok, s}
    else
      {:ok, :ok, s}
    end
  end

  def handle_info({:DOWN, _, _, pid, _}, s) do
    {producers, _} =
      Enum.split_with(s.producers, fn({_, p_pid}) -> p_pid != pid end)
    {:noreply, %{s | producers: producers}}
  end

  def merge(%{priorities: priorities, producers: producers, mount: mount}) do
    priorities = Enum.reverse(priorities)
    Enum.reduce(priorities, %{}, fn(priority, value) ->
      p_producers =
        Enum.filter(producers, fn({p_priority, _}) -> p_priority == priority end)

      Enum.reduce(p_producers, value, fn({_, pid}, value) ->
        p_value =
          Registry.match(S, pid, %{mount => %{}}) |> strip()
        p_value = if p_value == [], do: %{}, else: p_value
        p_value = Map.get(p_value, mount, %{})
        deep_merge(value, p_value)
      end)
    end)
  end

end
