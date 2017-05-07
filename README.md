# SystemRegistry

Eventually consistent global state and configuration registry with rate limiting.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `system_registry` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:system_registry, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/system_registry](https://hexdocs.pm/system_registry).

## Usage
SystemRegistry stores either `:state` and `:config` data at scopes. The value
at the scope is a map of top level keys. The process who supplies the keys at
the top level is the only process that can modify the keys. If that process
dies, all keys at all scopes that process owned are removed and a message is dispatched.

```elixir
SystemRegistry.transaction({:state, :network_interface, "eth0"}, %{address: "192.168.1.100"})
```
### Consumers

```elixir
SystemRegistry.register(10_000)
```

```elixir
SystemRegistry.unregister()
```

```elixir
def handle_in({:system_registry, %{state: %{network_interface: %{"eth0" => iface}}}, s) do
  {:noreply, s}
end
```
