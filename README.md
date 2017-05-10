# SystemRegistry

Local, serial, nested term storage and dispatch registry.

## Installation

The package can be installed by adding `system_registry` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:system_registry, github: "mobileoverlord/system_registry"}]
end
```

## Usage

SystemRegistry is a serial nested term storage and dispatch system. It takes a different approach to typical event sourcing patterns by focusing on data instead of events. SystemRegistry is local and serial to eliminate race conditions and eventually consistent by rate limiting consumers.


### Storage API

Data in SystemRegistry is stored in a map and represented as a tree of nodes. In order to perform operations on the registry data, you must pass a scope and a value.

Lets say we want to store a key `:a` with the value 1

```elixir
{:ok, {%{a: 1}, %{}}} = SystemRegistry.update([:a], 1)
```

Calls to update will return a 2 tuple delta in the form of `{new, old}`. Updates will either create keys or replace their value.

```elixir
{:ok, {%{a: 1}, %{}}} = SystemRegistry.update([:a], 1)
{:ok, {%{a: 2}, %{a: 1}}} = SystemRegistry.update([:a], 2)
```

At any time you can call `match/1` to fetch the current value for a match_spec in the registry.

```elixir
SystemRegistry.update([:a], 1)
%{a: 1} = SystemRegistry.match(%{a: :_})
%{} = SystemRegistry.match(%{b: :_})
```

Deleting data from the registry operates in a similar fashion. Calling delete will return the current state and recursively trim the tree if intermediate nodes are no longer associated to a value.

```elixir
{:ok, {%{a: 1}, %{}}} = SystemRegistry.update([:a], 1)
{:ok, %{}} = SystemRegistry.delete([:a])

{:ok, {%{a: %{b: %{c: 1}}}, %{}}}SystemRegistry.update([:a, :b, :c], 1)
{:ok, %{}} = SystemRegistry.delete([:a, :b, :c])
```

SystemRegistry operates off the principals of the node tree is represented as nested maps. This means that if the value of a scope is a map, it is recursively expanded into scopes.

```elixir
{:ok, {%{a: %{b: 1}}, %{}}} = SystemRegistry.update([:a], %{b: 1})
```

#### Transactions

Transactions let you compose update and delete functions so they are executed all at once. Under the hood, `update/2` and `delete/2` create a transaction with a single update / delete call. Lets see how to chain things together so they execute at once.

```elixir
{:ok, {%{a: 1, b: 2}, %{}}} =
  SystemRegistry.transaction
  |> SystemRegistry.update([:a], 1)
  |> SystemRegistry.update([:b], 2)
  |> SystemRegistry.commit
```

#### Processors

Processors are workers that can perform operations based off transactions. SystemRegistry ships with a default processor, `State`. Processors implement the Processor behaviour and have the capability of being notified on transaction validation and commit.

**Global State Processor**

The state processor monitors transactions for any who are writing values un the the top level scope `%{state: _}`. In addition to the caller fragment, these transactions are validated and committed to the `:global` fragment. Since this performs a deep merge, validation will fail if two processes attempt to overwrite another process's keys.

For example:
```elixir
Task.start(fn -> SR.update([:state, :a], 1))
{:error, {SystemRegistry.Processor.State, {:reserved_keys, [:a]}}} =
  SystemRegistry.update([:state, :a], 2)
```

The mount point for the state processor defaults to `:state` but can be configured in your application config.

```elixir
config :system_registry, SystemRegistry.Processor.State,
  mount: :somewhere_else
```

### Dispatch API

You can register and unregister to the SystemRegistry to receive messages when the contents of the registry change. Registrations default to to the `:global` fragment, but you can change this by passing in a different key such as a pid to access another processes fragment. You will receive the current value for the fragment upon registering to the key.

```elixir
{:ok, %{state: %{a: 1}}} = SystemRegistry.update([:state, :a], 1)
SystemRegistry.register()
SystemRegistry.update([:state, :b], 2)
## flush()
# {:system_registry, :global, %{state: %{a: 1, b: 2}}}
SystemRegistry.unregister()
SystemRegistry.update([:state, :b], 3)
## flush()
#
```
