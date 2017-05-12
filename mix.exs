defmodule SystemRegistry.Mixfile do
  use Mix.Project

  def project do
    [app: :system_registry,
     version: "0.1.1",
     elixir: "~> 1.4 or ~> 1.5.0-dev",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     docs: docs(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
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

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ex_doc, "~> 0.15", only: :dev}]
  end
end
