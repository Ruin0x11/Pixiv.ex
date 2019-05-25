defmodule Pixiv.MixProject do
  use Mix.Project

  def project do
    [
      description: "An unoffical API client for Pixiv.",
      version: "0.3.0",
      app: :pixiv,
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      elixir: "~> 1.8",
      deps: deps(),

      # Docs
      name: "Pixiv.ex",
      source_url: "https://github.com/BlindJoker/Pixiv.ex",
      homepage_url: "https://blindjoker.github.io/Pixiv.ex/"
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.1"},
      {:httpoison, "~> 1.5"},

      # Development dependencies.
      {:ex_doc, "~> 0.20", only: :dev, runtime: false},
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end
end
