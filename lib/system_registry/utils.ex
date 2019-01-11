defmodule SystemRegistry.Utils do
  @moduledoc false

  alias SystemRegistry.Storage.State, as: S

  @doc """
  Strip off the value returned by a Registry lookup.

  Many Registry functions return a list of {pid(), value()} tuples. Most
  calls only expect one result and only the value is needed. This extracts
  the value.
  """
  @spec strip(list()) :: any()
  def strip([]), do: nil

  def strip([{_value, result}]) do
    result
  end

  @spec deep_merge(map(), map()) :: map()
  def deep_merge(left, right) do
    Map.merge(left, right, &deep_resolve/3)
  end

  # Key exists in both maps, and both values are maps as well.
  # These can be merged recursively.
  defp deep_resolve(_key, left = %{}, right = %{}) do
    deep_merge(left, right)
  end

  # Key exists in both maps, but at least one of the values is
  # NOT a map. We fall back to standard merge behavior, preferring
  # the value on the right.
  defp deep_resolve(_key, _left, right) do
    right
  end

  @spec global() :: any()
  def global do
    Registry.lookup(S, :global) |> strip
  end
end
