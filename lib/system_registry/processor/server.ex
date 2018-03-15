defmodule SystemRegistry.Processor.Server do
  use GenServer

  alias SystemRegistry.Processor

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def apply(transaction) do
    GenServer.cast(__MODULE__, {:apply, transaction})
    transaction
  end

  def register_processor({mod, pid}) do
    GenServer.call(__MODULE__, {:register_processor, {mod, pid}})
  end

  def init(opts) do
    {:ok, opts}
  end

  def handle_cast({:apply, t}, processors) do
    with :ok <- Processor.call(processors, :validate, [t]),
         :ok <- Processor.call(processors, :commit, [t]) do
      :ok
    else
      error ->
        if Keyword.get(t.opts, :notify_on_error, false) do
          send(t.pid, {:system_registry, :transaction_failed, {t, error}})
        end
    end

    {:noreply, processors}
  end

  def handle_call({:register_processor, {mod, pid}}, _from, processors) do
    {:reply, :ok, [{mod, pid} | processors]}
  end
end
