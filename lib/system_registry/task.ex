defmodule SystemRegistry.Task do
  @moduledoc """
  Creates a process that executes a function anytime the contents of a given
  `SystemRegistry` scope change.

  For example, to perform an operation every time that the IPv4 address changes
  on `"wlan0"`, do this:

      {SystemRegistry.Task,
       [
         [:state, :network_interface, "wlan0", :ipv4_address],
         fn {_old, _new} ->
           # Do something
         end
       ]}

  This technique should be used sparingly and only for performing simple side
  effects to state change. 
  """

  use GenServer

  def child_spec([scope, fun]) do
    child_spec([scope, fun, []])
  end

  def child_spec([scope, fun, opts]) do
    %{
      id: opts[:id] || __MODULE__,
      start: {__MODULE__, :start_link, [scope, fun, opts]}
    }
  end

  @doc """
  Starts a task as part of a supervision tree.
  """
  @spec start_link(SystemRegistry.scope(), (() -> any), [term]) :: {:ok, pid}
  def start_link(scope, fun, opts \\ []) do
    GenServer.start_link(__MODULE__, {scope, fun}, opts)
  end

  # GenServer API

  @doc false
  def init({scope, fun}) do
    SystemRegistry.register()

    {:ok,
     %{
       scope: scope,
       fun: fun,
       value: nil
     }}
  end

  def handle_info({:system_registry, :global, registry}, state) do
    new_value = get_in(registry, state.scope)
    handle_update(new_value, state)
  end

  defp handle_update(value, %{value: value} = state) do
    {:noreply, state}
  end

  defp handle_update(new_value, %{value: old_value} = state) do
    state.fun.({new_value, old_value})
    {:noreply, %{state | value: new_value}}
  end
end
