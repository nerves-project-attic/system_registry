# SystemRegistry

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
