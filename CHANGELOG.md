# SystemRegistry

## v0.8.0

  * Enhancements
    * Decouple producers from global state server.
   
    Prior to 0.8.0, committing transactions would block system_registry until the 
    transaction was applied or rejected. Callers are now detached from the global 
    state server.

    Important note:
    This change in behaviour means that transactions that fail validation
    will not return an error immediately. Instead, if a process is interested 
    in errors, the transaction option `notify_on_error: true` must be set.

## v0.7.0

  * Enhancements
    * Moved Term Storage out to its own app

## v0.6.1

  * Enhancements
    * Fix Elixir 1.6 warnings

## v0.6.0

  * Enhancements
    * Added `SystemRegistry.Task` for a supervised process that executes a function
    anytime the contents of a given system_registry scope changes.

## v0.5.0

  * Enhancements
    * Added simple persistence mainly for use with the
    `SystemRegistry.Processors.Config` processor.
  * Bug Fixes
    * Processor behaviour passes all call / cast through to the implementation.

## v0.4.0

  * Enhancements
    * SystemRegistry.Processor.Config no longer requires the top level application to declare the priorities. Defaults to `[:debug, :_, :default]` which allows `:_` to be used to represent any applications that have not been specifically declared.

## v0.3.0

  * Bug Fixes
    * register will not return the current state for the key. Instead, the registrant will queued a message.
    * added update_in/3 for modifying the value of a scope transactionally.

## v0.2.1

  * Bug Fixes
    * Deleting a node would cause all node bindings to be deleted.

## v0.2.0

  * Enhancements
    * nodes and their values can be moved to another node
  * Bug Fixes
    * deleting an inner node did not delete all leaf nodes

## v0.1.2

  * Bug Fixes
    * Prevent inter nodes from being turned into leaf nodes if not all leafs are owned in :global
    * Clean up bindings when converting inter nodes to leafs

## v0.1.1

  * Bug Fixes
    * Processes were being monitored multiple times
    * State processor was not handling deletes properly
