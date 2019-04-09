defmodule Pixiv.MixProject do
  use Mix.Project

  def project do
    [
      app: :pixiv,
      version: "0.2.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:jason, "~> 1.1"},
      {:httpoison, "~> 1.5"},

      ## Development dependencies
      {:ex_doc, "~> 0.14", only: :dev, runtime: false}
    ]
  end
end
