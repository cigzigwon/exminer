defmodule Miner.MixProject do
  use Mix.Project

  def project do
    [
      app: :miner,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Miner, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.4"},
      {:floki, "~> 0.20.0"},
      {:poison, "~> 4.0"}
    ]
  end
end
