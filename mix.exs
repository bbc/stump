defmodule Stump.MixProject do
  use Mix.Project

  def project do
    [
      app: :stump,
      version: "1.5.0",
      elixir: "~> 1.8",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      env: [time_api: Stump.Time.DateTime]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.1"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description do
    """
      An Elixir Log Wrapper allows Maps and Strings to be passed to the Elixir Logger, along with that it will ouput to JSON.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md"],
      maintainers: [
        "bbc",
        "JoeARO",
        "woodyblah",
        "james-bowers",
        "ettomatic",
        "samfrench",
        "alexmuller"
      ],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/bbc/stump", "Docs" => "https://hexdocs.pm/stump/"}
    ]
  end
end
