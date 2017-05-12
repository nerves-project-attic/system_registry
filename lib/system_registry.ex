defmodule SystemRegistry do
  @moduledoc """
  The System Registry is a global storage and dispatch system for state and configuration.
  Processes can supply state and expose configuration for other processes to query.
  """

  @type scope ::
    {:state | :config, group :: atom, component :: term}

  alias SystemRegistry.{Local, Transaction, Registration}
  alias SystemRegistry.Storage.State, as: S
  import SystemRegistry.Utils

  @doc """
  Returns a transaction struct to pass to update/3 and delete/4 to chain
  modifications to to group. Prevents notifying registrants for each action.
  """
  @spec transaction(opts :: keyword()) :: Transaction.t
  def transaction(opts \\ []) do
    Transaction.begin(opts)
  end

  @doc """
  Commit a transaction. Attempts to apply all changes. If successful, will notify_all.
  """
  @spec commit(Transaction.t) ::
    {:ok, map} | {:error, term}
  def commit(transaction) do
    GenServer.call(Local, {:commit, transaction})
  end

  @doc """
    Execute an transaction to insert or modify state, or config
  """
  @spec update(Transaction.t, scope :: tuple, value :: term) ::
    {:ok, map} | {:error, term}
  def update(_, _, _ \\ nil)
  def update(%Transaction{} = t, scope, value) when not is_nil(scope) do
    Transaction.update(t, scope, value)
  end

  def update(scope, value, opts) do
    transaction(opts)
    |> update(scope, value)
    |> commit()
  end



  @doc """
    Execute an transaction to delete keys
  """
  @spec delete(Transaction.t, scope) ::
    {:ok, map} | {:error, term}
  def delete(_, _ \\ nil)
  def delete(%Transaction{} = t, scope) when not is_nil(scope) do
    Transaction.delete(t, scope)
  end

  def delete(scope, opts) do
    opts = opts || []
    transaction(opts)
    |> delete(scope)
    |> commit()
  end



  @doc """
  Delete all keys owned by the calling process
  """
  @spec delete_all(pid) ::
    {:ok, map} | {:error, term}
  def delete_all(pid \\ nil) do
    GenServer.call(Local, {:delete_all, (pid || self())})
  end

  @doc """
  Query the SystemRegistry using a match spec
  """
  @spec match(key :: term, match_spec :: term) :: map
  def match(key \\ :global, match_spec) do
    value =
      Registry.match(S, key, match_spec) |> strip()
    case value do
      [] -> %{}
      value -> value
    end
  end

  @doc """
    Register process to receive notifications
  """
  @spec register(opts :: keyword) ::
    {:ok, map} | {:error, term}
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
  @spec unregister(key :: term) ::
    :ok | {:error, term}
  def unregister(key \\ :global) do
    Registration.unregister(key)
  end

  @doc """
    Unregister process from receiving notifications
  """
  @spec unregister_all(pid) ::
    :ok | {:error, term}
  def unregister_all(pid \\ nil) do
    Registration.unregister_all((pid || self()))
  end

end
