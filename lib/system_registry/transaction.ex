defmodule SystemRegistry.Transaction do

  alias SystemRegistry.Binding, as: B
  alias SystemRegistry.State, as: S

  import SystemRegistry.Utils

  def ownership(scope, keys, pid) do
    scope_set =
      Registry.lookup(B, scope)
      |> strip
      |> List.first

    {free, reserved} =
      case scope_set do
        nil -> {keys, []}
        scope_set ->
          Enum.reduce(keys, {[], []}, fn(key, {free, reserved}) ->
            value = Enum.find(scope_set, fn
              ({_, ^key}) -> true
              _ -> false
            end)

            case value do
              nil -> {[key | free], reserved}
              {^pid, _} -> {free, reserved}
              _ -> {free, [key | reserved]}
            end
          end)
      end
  end

  def apply_ownership(scope, keys, owner) do
    put_set(scope, Enum.map(keys, &({owner, &1})))
    put_set(owner, Enum.map(keys, &({scope, &1})))
  end

  def free_ownership(scope, keys, owner) do
    delete_set(scope, Enum.map(keys, &({owner, &1})))
    delete_set(owner, Enum.map(keys, &({scope, &1})))
  end

  def apply_update(scope, value) do
    scope = scope_map(scope, value)
    Registry.update_value(S, :global, &deep_merge(&1, scope))
  end

  def apply_delete(scope, keys) do
    scope = Tuple.to_list(scope)
    Registry.update_value(S, :global, fn(global) ->
      Enum.reduce(keys, global, fn(key, global) ->
        update_in(global, scope, &Map.delete(&1, key))
      end)
    end)
  end

  def put_set(key, values) when is_list(values) do
    Registry.register(B, key, MapSet.new())
    Registry.update_value(B, key, fn(current) ->
      Enum.reduce(values, current, &MapSet.put(&2, &1))
    end)
  end

  def put_set(key, value) do
    Registry.register(B, key, MapSet.new())
    Registry.update_value(B, key, &MapSet.put(&1, value))
  end

  def delete_set(key, values) when is_list(values) do
    Registry.update_value(B, key, fn(current) ->
      Enum.reduce(values, current, &MapSet.delete(&2, &1))
    end)
  end

  def delete_set(key, value) do
    Registry.update_value(B, key, &MapSet.delete(&1, value))
  end

end
