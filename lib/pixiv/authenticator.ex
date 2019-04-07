defmodule Pixiv.Authenticator do
  @moduledoc """
  Handles authentication requests, responses and expiration.
  """

  alias Pixiv.Credentials

  def login(username, password) do
    authenticate(grant_type: "password", username: username, password: password)
  end

  def refresh(credentials, lazy \\ true)

  def refresh(%Credentials{refresh_token: token}, false) do
    authenticate(grant_type: "refresh_token", refresh_token: token)
  end

  def refresh(credentials, true) do
    if Credentials.expired?(credentials) do
      refresh(credentials, false)
    else
      {:noop, credentials}
    end
  end

  defp authenticate(params) do
    with {:ok, %{status_code: 200, body: body}} <- send_auth_request(params),
         {:ok, response} <- Jason.decode(body) do
      {:ok, response_to_tokens(response)}
    else
      {:error, %{reason: reason}} ->
        {:error, reason}

      {:ok, %{status_code: 400}} ->
        {:error, "Unauthorized! Maybe your pixiv username or password is wrong?"}

      _ ->
        {:error, "Unknown error while parsing response from Pixiv."}
    end
  end

  defp response_to_tokens(%{"response" => response}) do
    Credentials.new(
      response["access_token"],
      response["refresh_token"],
      response["expires_in"]
    )
  end

  defp send_auth_request(params) do
    form =
      Keyword.merge(params,
        client_id: Pixiv.client_id(),
        client_secret: Pixiv.client_secret(),
        get_secure_url: 1
      )

    HTTPoison.post(Pixiv.auth_url(), {:form, form}, Pixiv.headers())
  end
end
