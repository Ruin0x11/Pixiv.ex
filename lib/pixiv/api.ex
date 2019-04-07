defmodule Pixiv.API do
  use HTTPoison.Base

  def process_request_headers(headers) do
    Pixiv.HTTP.process_request_headers(headers)
  end

  def process_request_options(options) do
    Pixiv.HTTP.process_request_options(options)
  end

  def process_request_url(url) do
    Pixiv.base_url() <> url
  end

  def process_response_body(body) do
    Jason.decode!(body)
  end
end
