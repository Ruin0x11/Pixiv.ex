defmodule Pixiv.HTTP do
  use HTTPoison.Base

  def process_request_options(options) do
    Enum.into(options, hackney: [pool: :pixiv_ex])
  end

  def process_request_headers(headers) do
    credentials()
    |> Pixiv.headers()
    |> Enum.into(headers)
    |> Enum.into([])
  end

  defp credentials do
    apply(Application.get_env(:pixiv, :storage), :credentials, [])
  end
end
