# SystemRegistry

[![Build Status](https://travis-ci.org/mobileoverlord/system_registry.svg?branch=master)](https://travis-ci.org/mobileoverlord/system_registry)

Local, transactional, nested term storage and dispatch registry.

## Installation

The package can be installed by adding `system_registry` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:system_registry, "~> 0.1"}]
end
```

## Usage

SystemRegistry is a transactional nested term storage and dispatch system. It takes a different approach to a typical publish-subscribe pattern by focusing on data instead of events. SystemRegistry is local (as opposed to distributed) and transactional (as opposed to asynchronous) to eliminate race conditions. It also supports eventual consistency with rate-limiting consumers that control how often they receive state updates.

### Storage API

Data in SystemRegistry is stored as a tree of nodes, represented by a nested map. In order to perform operations on the registry data, you specify the scope of the operation as a list of keys to walk to the desired tree node.

Let's say we want to store a top-level key `:a` with the value `1`. We would call `update/2` like this:

```elixir
{:ok, {%{a: 1}, %{}}} = SystemRegistry.update([:a], 1)
```

Calls to `update/2` return a delta-state as a 2-tuple of `{new, old}`. Updates will either create keys (tree nodes) or replace their value.

```elixir
{:ok, {%{a: 1}, %{}}} = SystemRegistry.update([:a], 1)
{:ok, {%{a: 2}, %{a: 1}}} = SystemRegistry.update([:a], 2)
```

If we instead want to have sub-keys `:b` and `:c` under the top-level `:a` key, we could do so like this:

```elixir
{:ok, { %{a: %{b: 1}}, %{} }} = SystemRegistry.update([:a, :b], 1)
{:ok, { %{a: %{b: 1, c: 2}}, %{a: %{b: 1}} }} = SystemRegistry.update([:a, :c], 2)
```

At any time, you can call `match/1` to fetch the current value for a [`match_spec`](https://hexdocs.pm/elixir/Registry.html#match/3) in the registry.

```elixir
{:ok, {%{a: 1}, %{}}} = SystemRegistry.update([:a], 1)
%{a: 1} = SystemRegistry.match(%{a: :_})
%{} = SystemRegistry.match(%{b: :_})
```

Calling `delete/1` will return the current state and recursively trim the tree if intermediate nodes no longer have a value set.

```elixir
{:ok, {%{a: 1}, %{}}} = SystemRegistry.update([:a], 1)
{:ok, %{}} = SystemRegistry.delete([:a])

{:ok, {%{a: %{b: %{c: 1}}}, %{}}} = SystemRegistry.update([:a, :b, :c], 1)
{:ok, %{}} = SystemRegistry.delete([:a, :b, :c])
```

SystemRegistry operates on a tree of nodes represented as nested maps, so if the value assigned to a scope is a Map, it is recursively expanded into scopes.

```elixir
{:ok, { %{a: %{b: 1}}, %{} }} = SystemRegistry.update([:a], %{b: 1})
```

#### Transactions

Transactions let you compose `update` and `delete` functions using `transaction` and `commit` so they are executed atomically. Under the hood, `update/3` and `delete/2` pass a transaction through the pipeline and result in an atomic merged `update` and/or `delete` operation:

```elixir
{:ok, {%{a: 1, b: 2}, %{}}} =
  SystemRegistry.transaction
  |> SystemRegistry.update([:a], 1)
  |> SystemRegistry.update([:b], 2)
  |> SystemRegistry.commit
```

#### Processors

Processors are workers that can perform operations based on transactions. SystemRegistry ships with a default `State` processor. Processors implement the `Processor` behaviour and have the capability of being consulted during transaction validation and notified of committed transactions.

**Global State Processor**

The `State` processor monitors transactions for any that are writing values to the top-level `:state` scope.
Since updates performs a deep merge, the `State` processor will cause validation to fail if a processes attempts to overwrite a sub-key of `:state` that has been set by a different process.

For example:
```elixir
Task.start(fn -> SystemRegistry.update([:state, :a], 1))

{:error, {SystemRegistry.Processor.State, {:reserved_keys, [:a]}}} = SystemRegistry.update([:state, :a], 2)
```

The mount point for the `State` processor defaults to `:state`, but can be configured in your application:

```elixir
config :system_registry, SystemRegistry.Processor.State,
  mount: :somewhere_else
```

**Global Config Processor**

The `Config` processor monitors transactions for any that are writing values to the top-level `:config` scope.
Values in the config scope can be written to by any process with a valid transaction.

It validates that the transaction option `:priority` is set to a value form the application configuration. You can use `:_` to specify any priority value other than the ones specified which includes `nil`.

```elixir
config :system_registry, SystemRegistry.Processor.Config,
  priorities: [
      :high,
      :medium,
      :low,
      :_
    ]
```

If priorities are not declared in the application config, the default priority
levels `[:debug, :_, :persistence, :default]` will be used.

Options can be passed in when starting a transaction, or when using `update` / `delete` directly.

```elixir
# Pass as options
SystemRegistry.update([:config, :a], 1, priority: :high)
# Or
SystemRegistry.transaction(priority: :high)
|> SystemRegistry.update([:config, :a], 1)
|> SystemRegistry.commit
```

When the global state is returned, it will be the merged result of the state set by each producing process in the priority order defined in the application config. In the example above, `:high` will take precedence over `:medium` and `:medium` over `:low` and so on. Any transactions that fall into the `:_` priority level will be merged together in no particular order.

The mount point for the `Config` processor defaults to `:config`, but can be configured in your application:

```elixir
config :system_registry, SystemRegistry.Processor.Config,
  mount: :somewhere_else
```

**Persistence**

Config values can be persisted using the term storage module. Persistence is enabled
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

The default path for term storage is at `/tmp/system_registry`

### Dispatch API

Registrants can be rate-limited to avoid overwhelming them with frequent state changes, while still eventually receiving an update of the complete state.
When writing code that reacts to changes in global state, it is often not necessary to process every event.
For example, let's say we have a process that performs an expensive operation when a certain chunk of state is changed.
If the process causing the state were to "flap" back and forth between states 100 times in a second, we may only care to react to that change after it is done "flapping".
If we set up a consumer with a 1000 ms min_interval rate-limit, it would receive the initial message and the final state when the time limit expires. You can also set hysteresis to represent the amount of time the system should wait before sending the current state prior to min_interval. min_interval and hysteresis default to 0.

You can `register` to and `unregister` from the SystemRegistry to receive messages when the contents of the registry change. Upon registration, the caller will receive the current state.

```elixir
{:ok, %{state: %{a: 1}}} = SystemRegistry.update([:state, :a], 1)
SystemRegistry.register(min_interval: 1000)

SystemRegistry.update([:state, :b], 2)

## flush()
#=> {:system_registry, :global, %{state: %{a: 1, b: 2}}}

SystemRegistry.unregister()
SystemRegistry.update([:state, :b], 3)
## flush()
#=> (nothing)
```

How rate-limiting works

```elixir
SystemRegistry.register(hysteresis: 50, min_interval: 1000)
SystemRegistry.update([:state, :b], 2)
## 50ms later
## flush()
#=> {:system_registry, :global, %{state: %{a: 1, b: 2}}}
SystemRegistry.update([:state, :b], 3)
SystemRegistry.update([:state, :b], 4)
## 1000ms later
## flush()
#=> {:system_registry, :global, %{state: %{a: 1, b: 2}}}
```
