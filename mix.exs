defmodule Pique.MixProject do
  use Mix.Project

  def project do
    [
      app: :pique,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env),
      deps: deps(),
      name: "Pique",
      source_url: "https://github.com/maxneuvians/pique",
      homepage_url: "https://github.com/maxneuvians/pique",
      docs: [
        main: "Pique"
      ],
      description: description(),
      package: package(),
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/test_handlers", "test/test_senders"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Pique, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:gen_smtp, "~> 0.15.0"}
    ]
  end

  defp description() do
    "An elixir wrapper around gen_smtp that makes handler and sender registration easier."
  end

  defp package() do
    [
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/maxneuvians/pique"}
    ]
  end
end
