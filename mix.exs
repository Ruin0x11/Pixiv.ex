defmodule Pixiv.MixProject do
  use Mix.Project

  def project do
    [
      app: :pixiv,
      version: "0.2.0",
      elixir: "~> 1.7",
      deps: deps(),
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.1"},
      {:httpoison, "~> 1.5"},

      # Development dependencies
      {:ex_doc, "~> 0.20", only: :dev, runtime: false},
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end
end
