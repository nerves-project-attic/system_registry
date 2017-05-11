# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :system_registry, SystemRegistry.Processor.Config,
  priorities: [
    :pa,
    :pb,
    :pc
  ]
