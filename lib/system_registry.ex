defmodule SystemRegistry do
  @moduledoc """
  The System Registry is a global storage and dispatch system for state and configuration.
  Processes can supply state and expose configuration for other processes to query.
  """

  @type scope ::
    {:state | :config, group :: atom, component :: term}

  alias SystemRegistry.Server
  alias SystemRegistry.State, as: S
  import SystemRegistry.Utils

  @doc """
    Execute an transaction to insert or modify state, or config
  """
  @spec update(scope, value :: map) ::
    {:ok, map} | {:error, term}
  def update(scope, value) do
    GenServer.call(Server, {:update, scope, value})
  end

  @doc """
    Execute an transaction to delete state, or config
  """
  @spec delete(scope, keys :: [term]) ::
    {:ok, map} | {:error, term}
  def delete(scope, keys) do
    GenServer.call(Server, {:delete, scope, keys})
  end

  @spec match(match_spec :: term) :: map
  def match(match_spec) do
    value =
      Registry.match(S, :global, match_spec) |> strip
    case value do
      [] -> %{}
      [value] -> value
    end
  end

  @doc """
    Register process to receive notifications
  """
  @spec register(interval :: integer) ::
    {:ok, map} | {:error, term}
  def register(interval \\ 1_000) do
    case registered?(self()) do
      true -> {:error, :already_registered}
      false -> GenServer.call(Server, {:register, interval})
    end
  end

  @doc """
    Unregister process from receiving notifications
  """
  @spec unregister() ::
    :ok | {:error, term}
  def unregister() do
    GenServer.call(Server, {:unregister})
  end

end
