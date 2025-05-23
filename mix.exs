defmodule Redirector.Mixfile do
  use Mix.Project

  def project do
    [
      app: :redirector,
      version: "0.0.1",
      elixir: "~> 1.18.3",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Redirector.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:credo, ">= 1.6.5", only: [:dev]},
      {:dialyxir, ">= 1.0.0", only: [:dev], runtime: false},
      {:hackney, ">= 1.8.0"},
      {:phoenix, "> 1.6.0"},
      {:phoenix_view, ">= 1.0.0"},
      {:httpoison, ">= 1.8.1"},
      {:memoize, ">= 1.4.0"},
      {:plug_cowboy, ">= 2.1.0"},
      {:plug, ">= 1.7.0"},
      {:host, ">= 1.0.0"},
      {:cors_plug, ">= 1.5.0"},
      {:jason, "~> 1.2"},
      {:sentry, "~> 10.2.0"},
      {:yaml_elixir, ">= 2.8.0"},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end
end
