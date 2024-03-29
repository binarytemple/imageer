defmodule Imageer.Mixfile do
  use Mix.Project

  def project do
    [
      app: :upload,
      version: "0.0.1",
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      #compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      compilers: [] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Upload.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  #  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]

  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      #    {:phoenix, "~> 1.3.2"},
      #    {:phoenix_pubsub, "~> 1.0"},
      #    {:phoenix_ecto, "~> 3.2"},
      #    {:postgrex, ">= 0.0.0"},
      #    {:phoenix_html, "~> 2.10"},
      #    {:phoenix_live_reload, "~> 1.1.3", only: :dev},
      #    {:gettext, "~> 0.11"},
      #    {:cowboy, "~> 1.1"},
      #
      {:ecto              , "~> 2.2"}  ,
      {:postgrex          , "~> 0.11"} ,
      {:gen_state_machine , "~> 2.0"}  ,
      {:ace               , "~> 0.16"} ,
      {:raxx              , "~> 0.15"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      #      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      #      "ecto.reset": ["ecto.drop", "ecto.setup"],
      #      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
