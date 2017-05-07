defmodule SystemRegistry.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(Registry, [:unique, SystemRegistry.Registration,
        [partitions: System.schedulers_online]],
        [id: SystemRegistry.Registration.Supervisor]),
      supervisor(Registry, [:unique, SystemRegistry.Binding,
        [partitions: System.schedulers_online]],
        [id: SystemRegistry.Binding.Supervisor]),
      supervisor(Registry, [:unique, SystemRegistry.State,
        [partitions: System.schedulers_online]],
        [id: SystemRegistry.State.Supervisor]),
      worker(SystemRegistry.Server, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SystemRegistry.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
