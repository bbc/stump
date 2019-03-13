defmodule EventLogger.MixProject do
  use Mix.Project

  def project do
    [
      app: :event_logger,
      version: "0.1.0",
      elixir: "~> 1.8",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description,
      package: package
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 3.1"}
    ]
  end

  defp description do
    """
      A logging library that will ouput to JSON given a log level and a message to log.
    """
  end

  defp package do
    [
     files: ["lib", "mix.exs", "README.md"],
     maintainers: ["bbc", "JoeARO", "woodyblah", "james-bowers", "ettomatic", "samfrench", "alexmuller"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/JoeARO/event_logger",
              "Docs" => "https://hexdocs.pm/event_logger/"}
     ]
  end
end