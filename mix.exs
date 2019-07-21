defmodule Pixiv.MixProject do
  use Mix.Project

  @version "0.3.1"
  @description "An unoffical API client for Pixiv."

  def project do
    [
      description: @description,
      version: @version,
      app: :pixiv,
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,

      # Deps
      elixir: "~> 1.8",
      deps: deps(),

      # Docs
      docs: docs(),
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
      {:credo, "~> 1.1", only: :dev, runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end

  def docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      source_url: "https://github.com/BlindJoker/Pixiv.ex",
      extras: [
        "README.md"
      ]
    ]
  end
end
