defmodule SystemRegistry.Global do
  use GenServer

  alias SystemRegistry.Storage.State, as: S
  alias SystemRegistry.Transaction

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def put(scope, value) do
    GenServer.call(__MODULE__, {:put, scope, value}, :infinity)
  end

  def apply_updates(updates, nodes) do
    GenServer.call(__MODULE__, {:update, updates, nodes}, :infinity)
  end

  def apply_deletes(deletes, nodes) do
    GenServer.call(__MODULE__, {:delete, deletes, nodes}, :infinity)
  end

  def init(_) do
    Registry.register(S, :global, %{})
    {:ok, %{}}
  end

  def handle_call({:put, scope, value}, _, s) do
    reply =
      Registry.update_value(S, :global, fn(r_value) ->
        case scope do
          [_ | _] = scope -> update_in(r_value, scope, value)
          key -> Map.put(r_value, key, value)
        end
      end)
    {:reply, reply, s}
  end

  def handle_call({:update, updates, nodes}, _, s) do
    reply =
      Registry.update_value(S, :global, fn(value) ->
        Transaction.apply_bindings(:global, nodes)
        Transaction.apply_updates(value, updates)
      end)
    {:reply, reply, s}
  end

  def handle_call({:delete, deletes, nodes}, _, s) do
    reply =
      Registry.update_value(S, :global, fn(value) ->
        Transaction.remove_bindings(:global, nodes)
        Transaction.apply_deletes(value, deletes, :global)
      end)
    {:reply, reply, s}
  end

end
