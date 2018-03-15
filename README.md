# SystemRegistry

[![CircleCI](https://circleci.com/gh/nerves-project/system_registry.svg?style=svg)](https://circleci.com/gh/nerves-project/system_registry)

Local, transactional, nested term storage and dispatch registry.

## Installation

The package can be installed by adding `system_registry` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:system_registry, "~> 0.1"}]
end
```

## Overview

SystemRegistry is a nested term storage and dispatch system. It takes a different 
approach to the typical publish-subscribe pattern by focusing on data instead of 
events. SystemRegistry is local (as opposed to distributed) and transactional 
(as opposed to asynchronous) in order to eliminate race conditions. SystemRegistry 
is similar to Elixir.Registry but differs in that it is intended to construct a 
single global state that any process can contribute to and register to consume. 
Registrants are rate-limited to control how often they receive state updates and 
will eventually become consistent. Rate limiting decouples the consumers from 
the publisher's update interval, enabling consumers to shed unnecessary load.

Data is stored in system registry as a tree of nodes, represented by a nested map. 
The tree of nodes is comprised of two types of nodes.

  * internal node: A key with a value that **is** a map.
  * leaf node: A key wth a value that **is not** a map.

The tree is navigated using a list of keys representing the path to the desired 
leaf node called a `scope`.

Example:
```elixir
%{state: %{network_interface: %{"wlan0" => %{ipv4_address: "192.168.1.100"}}}}
```

In this example, there is only one leaf node, `ipv4_address`, located at the 
scope `[:state, :network_interface, "wlan0", :ipv4_address]`

Processes contribute data to SystemRegistry by applying a transaction. A transaction 
can modify data by composing one or many calls to update, delete, or move. Registrants 
are notified of a change once the entire transaction has been successfully applied.

Data flows through SystemRegistry in two phases. First, process data is stored in 
a separate fragment labeled by the caller pid and only contains the applied 
transactions of the caller. Second, the local pid fragment is then applied to 
the global state through a `SystemRegistry.Processor`.

Processors are workers that implement the `SystemRegistry.Processor` behaviour 
and are the only means of moving data from local fragments to the global state. 
Processors implement two callback methods: `handle_validate/2` and `handle_commit/2`. 
A transaction can only be committed if all processors return `:ok` during the 
validation sequence. If a transaction fails validation, it will only return an error 
to the caller if the transaction option `:notify_on_error` is `true`. Transactions 
that result in errors will not clean up the local fragment state. Processor validation 
errors are accumulated and returned in the case of an unsuccessful commit. 
SystemRegistry automatically starts two processors for state and config.

**Global State Processor**

The `State` processor monitors transactions for any that are writing values to 
the top-level `:state` scope. Since updates performs a deep merge, the `State` 
processor will cause validation to fail if a processes attempts to overwrite a 
sub-key of `:state` that has been set by a different process.

For example:
```elixir
Task.start(fn -> SystemRegistry.update([:state, :a], 1))

{:error, {SystemRegistry.Processor.State, {:reserved_keys, [:a]}}} = SystemRegistry.update([:state, :a], 2)
```

The mount point for the `State` processor defaults to `:state`, but can be 
configured in your application:

```elixir
config :system_registry, SystemRegistry.Processor.State,
  mount: :somewhere_else
```

**Global Config Processor**

The `Config` processor monitors transactions for any that are writing values to 
the top-level `:config` scope. Values in the config scope can be written to by 
any process with a valid transaction.

It validates that the transaction option `:priority` is set to a value form the 
application configuration. You can use `:_` to specify any priority value other 
than the ones specified which includes `nil`.

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
SystemRegistry.update([:config, :a], 1, priority: :debug)
# Or
SystemRegistry.transaction(priority: :debug)
|> SystemRegistry.update([:config, :a], 1)
|> SystemRegistry.commit
```

When the global state is returned, it will be the merged result of the state set 
by each producing process in the priority order defined in the application config. 
In the example above, `:high` will take precedence over `:medium` and `:medium` 
over `:low` and so on. Any transactions that fall into the `:_` priority level 
will be merged together in no particular order.

The mount point for the `Config` processor defaults to `:config`, but can be 
configured in your application:

```elixir
config :system_registry, SystemRegistry.Processor.Config,
  mount: :somewhere_else
```

## Usage

**update**

```elixir
{:ok, {%{state: 1}, %{}}} = SystemRegistry.update([:state], 1)
```

Calls to `update/2` return a delta-state as a 2-tuple of `{new, old}`. Updates 
will either create keys (leaf nodes) or replace their value.

```elixir
{:ok, {%{state: 1}, %{}}} = SystemRegistry.update([:state], 1)
{:ok, {%{state: 2}, %{state: 1}}} = SystemRegistry.update([:state], 2)
```

If we instead want to have sub-keys `:a` and `:b` under the top-level `:state` key, 
we could do so like this:

```elixir
{:ok, {%{state: %{a: 1}}, %{}} = SystemRegistry.update([:state, :a], 1)
{:ok, {%{state: %{a: 1, b: 2}}, %{state: %{a: 1}}} = SystemRegistry.update([:state, :b], 2)
```

If a map is provided as the value for a key, the map is recursively expanded into 
a series of update calls representing the leaf nodes.

```elixir
{:ok, {%{state: %{a: 1, b: 2}}, %{state: %{a: 1}}} = SystemRegistry.update([:state], %{a: 1, b: 2})
```

Data can also be updated in place using `update_in/2`

```elixir
SystemRegistry.update([:state, :my_list], [1])
{:ok, {%{state: %{my_list: [1]}}, %{}}}

SystemRegistry.update_in([:state, :my_list], fn(value) -> [2 | value] end)
{:ok, {%{state: %{my_list: [1, 2]}}, %{state: %{my_list: [1]}}}
```

**query**

At any time, you can call `match/1` to fetch the current value of the registry 
if the [`match_spec`] matches(https://hexdocs.pm/elixir/Registry.html#match/3) 
in the registry.

```elixir
{:ok, {%{a: 1}, %{}}} = SystemRegistry.update([:a], 1)
%{a: 1} = SystemRegistry.match(self(), %{a: :_})
%{} = SystemRegistry.match(self(), %{b: :_})
```
**Note:** If you're not using a processor (like the included `:config` or `:state`) your updates will be applied to the `local` fragment. To retrieve them you must pass the pid as the first argument to `match`. 

When using the `global` storage fragment via `:state`, `:config` or a custom processor you may omit the pid.

```elixir
iex(1)> {:ok, {new, old}} = SystemRegistry.update([:state, :a], 1)
{:ok, {%{state: %{a: 1}}, %{}}}
iex(2)> SystemRegistry.match(%{state: %{a: :_}})
%{state: %{a: 1}}
```

**delete**

Calling `delete/1` will return the current state and recursively trim the tree 
of any internal nodes which have a value of `%{}`.

```elixir
{:ok, {%{a: 1}, %{}}} = SystemRegistry.update([:a], 1)
{:ok, %{}} = SystemRegistry.delete([:a])

{:ok, {%{a: %{b: %{c: 1}}}, %{}}} = SystemRegistry.update([:a, :b, :c], 1)
{:ok, %{}} = SystemRegistry.delete([:a, :b, :c])
```

SystemRegistry operates on a tree of nodes represented as nested maps, so if the
value assigned to a scope is a Map, it is recursively expanded into scopes.

```elixir
{:ok, {%{a: %{b: 1}}, %{}}} = SystemRegistry.update([:a], %{b: 1})
```

**move**

Nodes can be moved from one scope to another. You can move both leaf nodes or 
internal nodes.

```
SystemRegistry.update([:a], 1)
{:ok, {%{a: 1}, %{}}}
SystemRegistry.move([:a], [:b])
{:ok, {%{b: 1}, %{a: 1}}}

iex> SystemRegistry.update([:a], 1)
{:ok, {%{a: 1}, %{}}}
iex> SystemRegistry.transaction |> SystemRegistry.move([:a], [:b]) |> SystemRegistry.commit
{:ok, {%{b: 1}, %{a: 1}}}
```

**Transactions**

Transactions let you compose `update` and `delete` functions using `transaction` and 
`commit` so they are executed atomically. Under the hood, `update/3` and `delete/2` 
pass a transaction through the pipeline and result in an atomic merged `update` 
and/or `delete` operation:

```elixir
{:ok, {%{a: 1, b: 2}, %{}}} =
  SystemRegistry.transaction
  |> SystemRegistry.update([:a], 1)
  |> SystemRegistry.update([:b], 2)
  |> SystemRegistry.commit
```

## Dispatch API

Registrants can be rate-limited to avoid overwhelming them with frequent state 
changes, while still eventually receiving an update of the complete state.
When writing code that reacts to changes in global state, it is often not necessary 
to process every event. For example, let's say we have a process that performs an 
expensive operation when a certain chunk of state is changed. If the process causing 
the state were to "flap" back and forth between states 100 times in a second, 
we may only care to react to that change after it is done "flapping". If we set 
up a consumer with a 1000 ms min_interval rate-limit, it would receive the initial 
message and the final state when the time limit expires. You can also set 
hysteresis to represent the amount of time the system should wait before sending 
the current state prior to min_interval. min_interval and hysteresis default to 0.

You can `register` to and `unregister` from the SystemRegistry to receive messages 
when the contents of the registry change. Upon registration, the caller will 
receive the current state.

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
