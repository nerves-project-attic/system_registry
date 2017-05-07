# SystemRegistry

Eventually consistent global state and configuration registry with rate limiting.

## Installation

The package can be installed by adding `system_registry` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:system_registry, "~> 0.1.0"}]
end
```

## Usage

**Scopes and Values**
SystemRegistry stores data in a single chunk, but the ownership of values are
assigned by scopes.

A scope is defined as:
`{bucket :: :state | :config, type :: atom, subtype :: term}`

At the end of the scope is a map of values. For example lets say we have the scope `{:state, :network_interface, "eth0"}` with a value of `{address: "192.168.1.100"}`

This would expand into the global as:
```elixir
%{state:
  %{network_interface:
    %{"eth0" =>
      %{address: "192.168.1.100"}
    }
  }
}
```

**Ownership and Permissions**

Ownership is applied to the top level keys of the value map to the pid of the process who inserted the keys. If the process owner dies, their keys and values in all scopes are deleted from the global registry.

Buckets have different permissions:
  `:state` - Values can only be updated / deleted by the owner
  `:config` - Values can be updated by anyone, but only deleted by the owner.

In the following example, the key `:address` is being inserted for the first time:

```elixir
SystemRegistry.update({:state, :network_interface, "eth0"}, %{address: "192.168.1.100"})
```

If another process were to try to update the value of the `:address` key in this scope they would receive `{:error, {:reserved_keys, [:address]}}`


Owners can delete keys using `delete/2`. Lets take the following global state where we want to delete the `:address` key

`%{state: %{network_interface: %{"eth0" => "192.168.1.100"}}}`

Example:
```elixir
SystemRegistry.delete({:state, :network_interface, "eth0"}, [:address])
```

### Consumers

SystemRegistry notifications are rate limited at an interval and will become
eventually consistent. The concept is counter to typical event sourcing where
every event matters. SystemRegistry is different because its interested in delivering state and not events. Rate limiting is applied as a means of load shedding.

Lets take the following example.
We have a network interface that goes up and down 100 times in second. In a traditional event sourcing mechanism, we would receive 100 interspersed up/down messages. Lets say every time we have an up event, we perform an expensive network operation that blocks. In this situation, the mailbox would start to fill and load shedding would be difficult.

With SystemRegistry, rate limiting will eventually coalesce the flapping messages during the time when the consumer is being rate limited. At the expiration, the current state is delivered to the consumer.

**Registering and Unregistering**

Processes can register to SystemRegistry to receive global state updates.

Registering requires that you pass a rate limiting interval.
```elixir
SystemRegistry.register(10_000)
```

You can unregister
```elixir
SystemRegistry.unregister()
```

**Consuming Messages**

SystemRegistry will send the registered process a message in the following format.
`{:system_registry, global :: map}`

For example, if the network interface at eth0 updates the address, registrants would receive:

`{:system_registry, %{state: %{network_interface: %{"eth0" => "192.168.1.100"}}}}`
