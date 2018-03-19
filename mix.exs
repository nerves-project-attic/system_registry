defmodule SystemRegistry.Mixfile do
  use Mix.Project

  def project do
    [
      app: :system_registry,
      version: "0.8.0",
      elixir: "~> 1.4",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      description: description(),
      package: package(),
      docs: docs(),
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger], mod: {SystemRegistry.Application, []}]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp docs do
    [extras: ["README.md"], main: "readme"]
  end

  defp description do
    """
    Atomic nested term storage and dispatch registry
    """
  end

  defp package do
    [
      maintainers: ["Justin Schneck"],
      licenses: ["Apache 2.0"],
      links: %{"Github" => "https://github.com/nerves-project/system_registry"}
    ]
  end

  defp deps do
    [{:ex_doc, "~> 0.18", only: :dev}]
  end
end
