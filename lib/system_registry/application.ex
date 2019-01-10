defmodule SystemRegistry.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # Define workers and child supervisors to be supervised
    config_opts = Application.get_env(:system_registry, SystemRegistry.Processor.Config)
    state_opts = Application.get_env(:system_registry, SystemRegistry.Processor.State)

    workers = [
      {Registry, keys: :unique, name: SystemRegistry.Storage.Registration},
      {Registry, keys: :unique, name: SystemRegistry.Storage.Binding},
      {Registry, keys: :unique, name: SystemRegistry.Storage.State},
      SystemRegistry.Global,
      SystemRegistry.Registration,
      SystemRegistry.Processor.Server,
      {SystemRegistry.Processor.State, state_opts},
      {SystemRegistry.Processor.Config, config_opts}
    ]

    opts = [strategy: :one_for_one, name: SystemRegistry.Supervisor]
    Supervisor.start_link(workers, opts)
  end
end
