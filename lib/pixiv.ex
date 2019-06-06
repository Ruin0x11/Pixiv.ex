defmodule Pixiv do
  @moduledoc """
  An unofficial interface to the Pixiv API.

  Note that, in order to make API requests, a `t:Pixiv.Credentials.t/0` instance should
  be obtained and managed by the caller. For convenience, this library provides the
  `Pixiv.CredentialsCache` module in order to do those.
  """

  @doc """
  Base URL for the public API.
  """
  @spec base_url() :: String.t()
  def base_url, do: "https://public-api.secure.pixiv.net/v1"

  @doc """
  Endpoint for requesting and refreshing authentication tokens.
  """
  @spec auth_url() :: String.t()
  def auth_url, do: "https://oauth.secure.pixiv.net/auth/token"

  @doc """
  Public identifier used by OAuth2.
  """
  @spec client_id() :: String.t()
  def client_id, do: "MOBrBDS8blbauoSck0ZfDbtuzpyT"

  @doc """
  Private identifier used by OAuth2.
  """
  @spec client_secret() :: String.t()
  def client_secret, do: "lsACyCD94FhDUtGTXi3QzcFE2uU1hqtDaKeqrdwj"

  @doc """
  Request headers required to access Pixiv.
  """
  @spec headers() :: [{String.t(), String.t()}]
  def headers do
    [
      {"User-Agent", "PixivAndroidApp/5.0.64 (Android 6.0)"},
      {"Referer", "https://public-api.secure.pixiv.net/"}
    ]
  end

  @doc """
  Returns the request headers bound to `credentials`.
  """
  @spec headers_for(Pixiv.Credentials.t()) :: [{String.t(), String.t()}]
  def headers_for(credentials) do
    [
      {"Authorization", "Bearer #{credentials.access_token}"} | headers()
    ]
  end
end
