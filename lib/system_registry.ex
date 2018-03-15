defmodule SystemRegistry do
  @moduledoc """
    SystemRegistry is a transactional nested term storage and dispatch system.
    It takes a different approach to a typical publish-subscribe pattern by
    focusing on data instead of events. SystemRegistry is local
    (as opposed to distributed) and transactional (as opposed to asynchronous)
    to eliminate race conditions. It also supports eventual consistency with
    rate-limiting consumers that control how often they receive state updates.

    Data in SystemRegistry is stored as a tree of nodes, represented by a
    nested map. In order to perform operations on the registry data, you specify
    the scope of the operation as a list of keys to walk to the desired tree node.
  """

  @type scope :: [term]

  alias SystemRegistry.{Transaction, Registration, Processor}
  alias SystemRegistry.Storage.State, as: S
  import SystemRegistry.Utils

  @doc """
    Returns a transaction struct to pass to update/3 and delete/4 to chain
    modifications to to group. Prevents notifying registrants for each action.
    Example:

      iex> SystemRegistry.transaction |> SystemRegistry.update([:a], 1) |> SystemRegistry.commit
      {:ok, {%{a: 1}, %{}}}

  """
  @spec transaction(opts :: Keyword.t()) :: Transaction.t()
  def transaction(opts \\ []) do
    Transaction.begin(opts)
  end

  @doc """
    Commit a transaction. Attempts to apply all changes. If successful, will notify_all.
  """
  @spec commit(Transaction.t()) :: {:ok, {new :: map, old :: map}} | {:error, term}
  def commit(transaction) do
    t =
      Transaction.prepare(transaction)
      |> Processor.Server.apply()

    with {:ok, {new, _old} = delta} <- Transaction.commit(t),
         :ok <- Registration.notify(t.pid, new) do
      {:ok, delta}
    else
      error ->
        error
    end
  end

  @doc """
    Execute an transaction to insert or modify data.

    Update can be called on its own:

      iex> SystemRegistry.update([:a], 1)
      {:ok, {%{a: 1}, %{}}}

    Or it can be included as part of a transaction pipeline

      iex> SystemRegistry.transaction |> SystemRegistry.update([:a], 1) |> SystemRegistry.commit
      {:ok, {%{a: 1}, %{}}}

    Passing a map to update will recursively expand into a transaction
    for example this:

      iex> SystemRegistry.update([:a], %{b: 1})
      {:ok, {%{a: %{b: 1}}, %{}}}

    is equivalent to this:

      iex>  SystemRegistry.update([:a, :b], 1)
      {:ok, {%{a: %{b: 1}}, %{}}}
  """
  @spec update(one, scope, value :: any) :: Transaction.t() when one: Transaction.t()
  def update(_, _, _ \\ nil)

  def update(%Transaction{} = t, scope, value) when not is_nil(scope) do
    Transaction.update(t, scope, value)
  end

  @spec update(one, value :: any, opts :: Keyword.t()) ::
          {:ok, {new :: map, old :: map}} | {:error, term}
        when one: scope
  def update(scope, value, opts) do
    opts = opts || []

    transaction(opts)
    |> update(scope, value)
    |> Processor.Server.apply()
    |> commit()
  end

  @doc """
    Execute an transaction to modify data in place by passing a modifier function.

    Allows for the manipulation of the value at the scope. Useful for when the
    value needs to be modified in place.

    For Example:

      iex> SystemRegistry.update([:a], [1])
      {:ok, {%{a: [1]}, %{}}}
      iex> SystemRegistry.update_in([:a], fn(value) -> [2 | value] end)
      {:ok, {%{a: [2, 1]}, %{a: [1]}}}
  """
  @spec update_in(scope, (term -> term), opts :: keyword()) ::
          {:ok, {new :: map, old :: map}} | {:error, term}
  def update_in(scope, fun, opts \\ []) do
    t = Transaction.begin(opts)

    value =
      Registry.lookup(S, t.key)
      |> strip()
      |> get_in(scope)

    value = fun.(value)

    Transaction.update(t, scope, value)
    |> Processor.Server.apply()
    |> commit()
  end

  @doc """
    Move a node from one scope to another

    Move can be called on its own:

      iex> SystemRegistry.update([:a], 1)
      {:ok, {%{a: 1}, %{}}}
      iex> SystemRegistry.move([:a], [:b])
      {:ok, {%{b: 1}, %{a: 1}}}

    Or it can be included as part of a transaction pipeline

      iex> SystemRegistry.update([:a], 1)
      {:ok, {%{a: 1}, %{}}}
      iex> SystemRegistry.transaction |> SystemRegistry.move([:a], [:b]) |> SystemRegistry.commit
      {:ok, {%{b: 1}, %{a: 1}}}
  """
  @spec move(transaction, scope, scope) :: Transaction.t() when transaction: Transaction.t()
  def move(_, _, _ \\ nil)

  def move(%Transaction{} = t, old_scope, new_scope) when not is_nil(new_scope) do
    Transaction.move(t, old_scope, new_scope)
  end

  @spec move(scope_arg, scope, opts :: nil | Keyword.t()) ::
          {:ok, {new :: map, old :: map}} | {:error, term}
        when scope_arg: scope
  def move(old_scope, new_scope, opts) do
    opts = opts || []

    transaction(opts)
    |> move(old_scope, new_scope)
    |> Processor.Server.apply()
    |> commit()
  end

  @doc """
    Execute an transaction to delete keys and their values.

    Delete can be called on its own:

      iex> SystemRegistry.update([:a], 1)
      {:ok, {%{a: 1}, %{}}}
      iex> SystemRegistry.delete([:a])
      {:ok, {%{}, %{a: 1}}}

    Or it can be included as part of a transaction pipeline

      iex> SystemRegistry.update([:a], 1)
      {:ok, {%{a: 1}, %{}}}
      iex> SystemRegistry.transaction |> SystemRegistry.delete([:a]) |> SystemRegistry.commit
      {:ok, {%{}, %{a: 1}}}

    If you pass an internal node to delete, it will delete all the keys the process
    ownes under it.

      iex> SystemRegistry.update([:a, :b], 1)
      {:ok, {%{a: %{b: 1}}, %{}}}
      iex> SystemRegistry.delete([:a])
      {:ok, {%{}, %{a: %{b: 1}}}}

  """
  @spec delete(transaction, scope) :: Transaction.t() when transaction: Transaction.t()
  def delete(_, _ \\ nil)

  def delete(%Transaction{} = t, scope) when not is_nil(scope) do
    Transaction.delete(t, scope)
  end

  @spec delete(scope, Keyword.t() | nil) :: {:ok, {new :: map, old :: map}} | {:error, term}
  def delete(scope, opts) do
    opts = opts || []

    transaction(opts)
    |> delete(scope)
    |> Processor.Server.apply()
    |> commit()
  end

  @doc """
    Delete all keys owned by the calling process.

      iex> SystemRegistry.update([:a, :b], 1)
      {:ok, {%{a: %{b: 1}}, %{}}}
      iex> SystemRegistry.delete_all()
      {:ok, {%{}, %{a: %{b: 1}}}}

  """
  @spec delete_all(pid | nil) :: {:ok, {new :: map, old :: map}} | {:error, term}
  def delete_all(pid \\ nil) do
    pid = pid || self()

    Transaction.begin()
    |> Transaction.delete_all(pid, pid)
    |> Processor.Server.apply()
    |> commit()
  end

  @doc """
    Query the SystemRegistry using a match spec.

      iex> SystemRegistry.update([:a, :b], 1)
      {:ok, {%{a: %{b: 1}}, %{}}}
      iex> SystemRegistry.match(self(), :_)
      %{a: %{b: 1}}
      iex> SystemRegistry.match(self(), %{a: %{}})
      %{a: %{b: 1}}
      iex> SystemRegistry.match(self(), %{a: %{b: 2}})
      %{}
  """
  @spec match(key :: term, match_spec :: term) :: map
  def match(key \\ :global, match_spec) do
    value = Registry.match(S, key, match_spec) |> strip()

    case value do
      [] -> %{}
      value -> value
    end
  end

  @doc """
    Register process to receive notifications.
    Registrants are rate-limited and require that you pass an interval.
    Upon registration, the caller will receive the current state.

    options
      * `:hysteresis` - Default: 0, The amount of time to wait before delivering the first
        change message.
      * `:min_interval` - Default: 0, The minimum amount of time to wait after hysteresis,
        but before the next message is to be delivered.

    With both options defaulting to , you will receive every message.

    Examples

      iex> purge_mailbox = fn (self) -> 
      ...>   receive do
      ...>     _ -> self.(self)
      ...>   after
      ...>     50 -> :ok
      ...>   end
      ...> end
      iex> SystemRegistry.register()
      :ok
      iex> purge_mailbox.(purge_mailbox)
      :ok
      iex> SystemRegistry.update([:state, :a], 1)
      {:ok, {%{state: %{a: 1}}, %{}}}
      iex> :timer.sleep(50)
      :ok
      iex> Process.info(self())[:messages]
      [{:system_registry, :global, %{state: %{a: 1}}}]
      iex> SystemRegistry.unregister()
      :ok
      iex> purge_mailbox.(purge_mailbox)
      :ok
      iex> SystemRegistry.delete_all()
      {:ok, {%{}, %{state: %{a: 1}}}}
      iex> SystemRegistry.register(hysteresis: 10, min_interval: 50)
      :ok
      iex> purge_mailbox.(purge_mailbox)
      iex> SystemRegistry.update([:state, :a], 1)
      {:ok, {%{state: %{a: 1}}, %{}}}
      iex> :timer.sleep(10)
      iex> Process.info(self())[:messages]
      []
      iex> :timer.sleep(15)
      iex> Process.info(self())[:messages]
      [{:system_registry, :global, %{state: %{a: 1}}}]
      iex> purge_mailbox.(purge_mailbox)
      :ok
      iex> SystemRegistry.update([:state, :a], 2)
      {:ok, {%{state: %{a: 2}}, %{state: %{a: 1}}}}
      iex> Process.info(self())[:messages]
      []
      iex> :timer.sleep(50)
      :ok
      iex> Process.info(self())[:messages]
      [{:system_registry, :global, %{state: %{a: 2}}}]

  """
  @spec register(opts :: keyword) :: :ok | {:error, term}
  def register(opts \\ []) do
    key = opts[:key] || :global

    case Registration.registered?(key) do
      true -> {:error, :already_registered}
      false -> Registration.register(opts)
    end
  end

  @doc """
    Unregister process from receiving notifications
  """
  @spec unregister(key :: term) :: :ok | {:error, term}
  def unregister(key \\ :global) do
    Registration.unregister(key)
  end

  @doc """
    Unregister process from receiving notifications
  """
  @spec unregister_all(pid | nil) :: :ok | {:error, term}
  def unregister_all(pid \\ nil) do
    Registration.unregister_all(pid || self())
  end
end
