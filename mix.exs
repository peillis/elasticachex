defmodule Elasticachex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elasticachex,
      version: "1.1.2",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      name: "Elasticachex",
      source_url: "https://github.com/peillis/elasticachex",
      deps: deps(),
      docs: [main: "readme", extras: ["README.md"]]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
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
    [
      {:credo, "~> 0.10", only: :dev},
      {:ex_doc, "~> 0.19", only: :dev},
      {:socket, "~> 0.3"}
    ]
  end

  defp description do
    """
    An implementation of the Node Auto Discovery for Memcached in the
    ElastiCache service of AWS.
    See http://docs.aws.amazon.com/AmazonElastiCache/latest/UserGuide/AutoDiscovery.html
    """
  end

  defp package do
    [
      licenses: ["MIT"],
      maintainers: ["Enrique Martinez"],
      links: %{"GitHub" => "https://github.com/peillis/elasticachex"}
    ]
  end
end
