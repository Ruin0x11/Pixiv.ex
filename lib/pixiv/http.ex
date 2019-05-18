defmodule Pixiv.HTTP do
  use HTTPoison.Base

  def process_request_options(options) do
    Enum.into(options, hackney: [pool: :pixiv_ex])
  end

  def process_request_headers(headers) do
    Pixiv.headers(credentials()) ++ headers
  end

  defp credentials do
    Pixiv.credentials_cache().credentials()
  end
end
