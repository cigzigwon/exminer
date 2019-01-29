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
      {:socket, "~> 0.3.13"},
      {:poison, "~> 3.1.0"},
      {:joken, "~> 1.4.1"}
    ]
  end
end
