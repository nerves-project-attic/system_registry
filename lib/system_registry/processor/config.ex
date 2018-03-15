defmodule SystemRegistry.Processor.Config do
  use SystemRegistry.Processor

  @mount :config

  alias SystemRegistry.{Transaction, Global}
  alias SystemRegistry.Storage.State, as: S

  import SystemRegistry.Processor.Utils
  import SystemRegistry.Utils

  def put_priorities(priorities) do
    GenServer.call(__MODULE__, {:put_priorities, priorities})
  end

  def init(opts) do
    mount = opts[:mount] || @mount
    priorities = opts[:priorities] || default_priorities()

    {:ok,
     %{
       opts: opts,
       mount: mount,
       producers: [],
       priorities: priorities
     }}
  end

  def handle_validate(%Transaction{} = t, s) do
    updates = updates(t, s.mount)
    deletes = deletes(t, s.mount)

    priority = t.opts[:priority]

    if modified?(updates, deletes) do
      if priority in s.priorities or :_ in s.priorities do
        {:ok, :ok, s}
      else
        {:error,
         {__MODULE__,
          "Transaction tag: #{inspect(priority)} not in priorities: #{inspect(s.priorities)}"}, s}
      end
    else
      {:ok, :ok, s}
    end
  end

  def handle_commit(%Transaction{} = t, s) do
    updates = updates(t, s.mount)
    deletes = deletes(t, s.mount)

    if modified?(updates, deletes) do
      priority = t.opts[:priority]
      Process.monitor(t.pid)
      producers = [{priority, t.pid} | s.producers]
      s = %{s | producers: producers}
      Global.put(s.mount, merge(s))
      {:ok, :ok, s}
    else
      {:ok, :ok, s}
    end
  end

  def handle_call({:put_priorities, priorities}, _from, s) do
    {:reply, :ok, %{s | priorities: priorities}}
  end

  def handle_info({:DOWN, _, _, pid, _}, s) do
    {producers, _} = Enum.split_with(s.producers, fn {_, p_pid} -> p_pid != pid end)
    {:noreply, %{s | producers: producers}}
  end

  def merge(%{priorities: priorities, producers: producers, mount: mount}) do
    priorities = Enum.reverse(priorities)
    {reg, unreg} = Enum.split_with(producers, fn {priority, _} -> priority in priorities end)

    Enum.reduce(priorities, %{}, fn priority, value ->
      p_producers =
        case priority do
          :_ ->
            unreg

          priority ->
            Enum.filter(reg, fn {p_priority, _} -> p_priority == priority end)
        end

      Enum.reduce(p_producers, value, fn {_, pid}, value ->
        p_value = Registry.match(S, pid, %{mount => %{}}) |> strip()
        p_value = if p_value == [], do: %{}, else: p_value
        p_value = Map.get(p_value, mount, %{})
        deep_merge(value, p_value)
      end)
    end)
  end

  defp default_priorities() do
    [:debug, :_, :persistence, :default]
  end
end
