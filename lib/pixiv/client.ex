defmodule Pixiv.Client do
  @moduledoc """
  Thin wrapper over the Pixiv public API.
  """

  alias Pixiv.Credentials

  defmodule HTTP do
    @moduledoc false

    @options hackney: [pool: :pixiv]

    use HTTPoison.Base

    def process_request_url(path) do
      Pixiv.base_url() <> path
    end

    def process_request_options(options) do
      Keyword.merge(@options, options)
    end

    def process_response_body(body) do
      Jason.decode!(body)
    end
  end

  @doc """
  Issues a GET request to the given `path`, using `credentials` for authentication.
  """
  @spec get(Credentials.t(), String.t(), Keyword.t()) :: term
  def get(credentials, path, options \\ []) do
    headers = Pixiv.headers_for(credentials)
    HTTP.get(path, headers, options)
  end

  @doc """
  Issues a POST request to the given `path`, using `credentials` for authentication.
  """
  @spec post(Credentials.t(), String.t(), term, Keyword.t()) :: term
  def post(credentials, path, body, options \\ []) do
    headers = Pixiv.headers_for(credentials)
    HTTP.post(path, body, headers, options)
  end
end
