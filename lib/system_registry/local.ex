defmodule SystemRegistry.Local do
  @moduledoc false

  use GenServer

  alias SystemRegistry.{Transaction, Processor, Registration}
  alias SystemRegistry.Storage.State, as: S

  import SystemRegistry.Utils
  #import SystemRegistry.Transaction

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [opts], name: __MODULE__)
  end

  def register_processor({mod, pid}) do
    GenServer.call(__MODULE__, {:register_processor, {mod, pid}})
  end

  # GenServer API

  def init(_opts) do
    {:ok, %{
      processors: []
    }}
  end

  def handle_call({:register_processor, {mod, pid}}, _from, s) do
    {:reply, :ok, %{s | processors: [{mod, pid} | s.processors]}}
  end

  def handle_call({:commit, transaction}, _, s) do
    {:reply, commit(transaction, s), s}
  end

  def handle_call({:delete_all, pid}, _, s) do
    {:reply, delete_all(pid, s), s}
  end

  def handle_info({:DOWN, _, _, pid, _}, s) do
    Registration.unregister_all(pid)
    delete_all(pid, s)
    {:noreply, s}
  end

  defp delete_all(pid, s) do
    frag =
    Registry.lookup(S, pid)
    |> strip()

    t = Transaction.begin
    %{t | pid: pid, key: pid}
    |> Transaction.delete(frag)
    |> commit(s)
  end

  defp commit(%Transaction{pid: pid} = t, s) do
    with             {:ok, t} <- Transaction.prepare(t),
                          :ok <- Processor.call(s.processors, :validate, [t]),
                            _ <- Process.monitor(pid),
   {:ok, {new, _old} = delta} <- Transaction.commit(t),
                          :ok <- Registration.notify(pid, new),
                          :ok <- Processor.call(s.processors, :commit, [t]) do
      {:ok, delta}
    else
      error ->
        error
    end
  end

end
