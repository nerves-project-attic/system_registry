defmodule SystemRegistry.Global do
  use GenServer

  alias SystemRegistry.Storage.State, as: S
  alias SystemRegistry.Transaction

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def apply_updates(updates) do
    GenServer.call(__MODULE__, {:update, updates})
  end

  def apply_deletes(deletes) do
    GenServer.call(__MODULE__, {:delete, deletes})
  end

  def init(_) do
    Registry.register(S, :global, %{})
    {:ok, %{}}
  end

  def handle_call({:update, updates}, _, s) do
    reply =
      Registry.update_value(S, :global, fn(value) ->
        Transaction.apply_updates(value, updates)
      end)
    {:reply, reply, s}
  end

  def handle_call({:delete, deletes}, _, s) do
    reply =
      Registry.update_value(S, :global, fn(value) ->
        Transaction.apply_deletes(value, deletes)
      end)
    {:reply, reply, s}
  end

end
