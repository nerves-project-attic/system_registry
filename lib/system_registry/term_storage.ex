defmodule SystemRegistry.TermStorage do
  @moduledoc """
  Values can be persisted using the term storage module. Persistence is enabled
  for individual leaf nodes. The value for the leaf node is written to a file at the
  scope specified. For example, lets say we want to persist the value for the leaf node
  `[:config, :a]`. In the application that wants to persist this value, we would call:
  `SystemRegistry.TermStorage.persist([:config, :a])`. This cal would typically be made
  in the dependencies application start. Once persistence is enabled, term storage will
  make its own entry into the config with the value from disk using the priority
  `:persistence`. Using this technique, old values will remain saved on the file system
  but they will not be made available unless they are told to be persisted. Scopes to be
  persisted and the path to write persisted terms to can be set in the application config

  ```elixir
  config :system_registry, SystemRegistry.TermStorage,
    scopes: [
      [:config, :network_interface, "wlan0", :ssid],
      [:config, :network_interface, "wlan0", :psk],
    ],
    path: "/tmp/system_registry"
  ```
  """

  use GenServer

  @spec start_link(opts :: term) ::
    {:ok, pid} | {:error, reason :: term}
  @doc """
  Starts the TermStorage server
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @spec persist(SystemRegistry.scope) :: :ok
  @doc """
  A scope to a leaf node to be persisted upon change.

  For example, let's say that we want to make sure that the ssid for our wireless
  network is persisted between reboots:

      SystemRegistry.TermStorage.persist([:config, :network_interface, "wlan0", :ssid])
  """
  def persist(scope) do
    GenServer.call(__MODULE__, {:persist, scope})
  end

  # GenServer Callbacks

  def init(opts) do
    scopes = opts[:scopes] || []
    path = opts[:path] || "/tmp/system_registry"
    Enum.each(scopes, &notify(path, &1))
    SystemRegistry.register()
    {:ok, %{
      scopes: scopes,
      values: [],
      path: path
    }}
  end

  def handle_call({:persist, scope}, _from, s) do
    notify(s.path, scope)
    {:reply, :ok, %{s | scopes: [scope | s.scopes]}}
  end

  def handle_info({:system_registry, :global, reg}, s) do
    values =
      Enum.reduce(s.scopes, [], fn(scope, acc) ->
        old =
          case Enum.find(s.values, fn({v, _}) -> v == scope end) do
            nil -> nil
            {_, v} -> v
          end
        value = get_in(reg, scope)
        if value != old do
          put_value(s.path, scope, value)
        end
        [{scope, value} | acc]
      end)
    {:noreply, %{s | values: values}}
  end

  defp notify(path, scope) do
    if value = get_value(path, scope) do
      SystemRegistry.update(scope, value, priority: :persistence)
    end
  end

  defp put_value(path, scope, value) do
    SystemRegistry.update(scope, value, priority: :persistence)

    path = path(path, scope)
    path
    |> Path.dirname()
    |> File.mkdir_p()

    File.write!(path, :erlang.term_to_binary(value))
  end


  defp get_value(path, scope) do
    path = path(path, scope)
    case File.read(path) do
      {:ok, file} ->
        :erlang.binary_to_term(file) || nil
      _ -> nil
    end
  end

  defp path(path, scope) do
    scope = Enum.map(scope, &to_string/1)
    Path.join([path] ++ scope)
  end
end
