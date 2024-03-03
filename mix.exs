defmodule EctoMorphic.MixProject do
  use Mix.Project

  @source_url "https://github.com/Gigitsu/ecto_morphic"
  @version "0.1.0"

  def project do
    [
      app: :ecto_morphic,
      version: @version,
      elixir: "~> 1.15",
      deps: deps(),
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env()),

      # Hex
      description: "Polymorphic embeds in Ecto",
      package: package(),

      # Docs
      name: "Ecto Morphic",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, ">= 3.0.0"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:ecto_sql, "~> 3.9", only: :test},
      {:jason, "~> 1.4", only: :test},
      {:postgrex, "~> 0.16", only: :test}
    ]
  end

  defp aliases do
    [
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end

  defp package do
    [
      maintainers: ["Luigi Clemente"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url},
      files: ~w(.formatter.exs mix.exs README.md lib)
    ]
  end

  defp docs do
    [
      main: "EctoMorphic",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/ecto_morphic",
      source_url: @source_url
    ]
  end
end
