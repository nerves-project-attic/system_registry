defmodule SystemRegistry.Utils do

  alias SystemRegistry.Binding,   as: B
  alias SystemRegistry.State,     as: S

  def strip(values) do
    Enum.map(values, fn({_, result}) -> result end)
  end

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

  def global do
    Registry.lookup(S, :global) |> strip |> List.first
  end

  def registered?(from) do
    Registry.match(B, :registrations, {from, :_}) != []
  end

  def scope_map(scope, value) do
    scope
    |> Tuple.to_list()
    |> Enum.reverse
    |> Enum.reduce(value, &Map.put(%{}, &1, &2))
  end

end
