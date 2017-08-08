defmodule SystemRegistry.Mixfile do
  use Mix.Project

  def project do
    [app: :system_registry,
     version: "0.5.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     docs: docs(),
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger],
     mod: {SystemRegistry.Application, []}]
  end

  defp docs do
    [extras: ["README.md"],
     main: "readme"]
  end

  defp description do
    """
    Atomic nested term storage and dispatch registry
    """
  end

  defp package do
    [maintainers: ["Justin Schneck"],
     licenses: ["Apache 2.0"],
     links: %{"Github" => "https://github.com/mobileoverlord/system_registry"}]
  end

  defp deps do
    [{:ex_doc, "~> 0.15", only: :dev}]
  end
end
