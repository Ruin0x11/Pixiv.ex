defmodule Pixiv do
  @moduledoc """
  An unofficial interface to the Pixiv API.

  Note that, in order to make API requests, a `t:Pixiv.Credentials.t/0` instance should
  be obtained and managed by the caller. For convenience, this library provides the
  `Pixiv.CredentialsCache` module in order to do those.
  """

  def base_url, do: "https://public-api.secure.pixiv.net/v1"
  def auth_url, do: "https://oauth.secure.pixiv.net/auth/token"

  @doc """
  Returns the public identifier used by OAuth2.

  Taken from the Pixiv Android app.
  """
  def client_id, do: "MOBrBDS8blbauoSck0ZfDbtuzpyT"

  @doc """
  Returns the private identifier used by OAuth2.

  Taken from the Pixiv Android app.
  """
  def client_secret, do: "lsACyCD94FhDUtGTXi3QzcFE2uU1hqtDaKeqrdwj"

  @doc """
  Returns the headers as used through this library.
  """
  @spec headers() :: [{String.t(), String.t()}]
  def headers() do
    [
      {"User-Agent", "PixivAndroidApp/5.0.64 (Android 6.0)"},
      {"Referer", "https://public-api.secure.pixiv.net/"}
    ]
  end

  @doc """
  Returns the headers, bound to credentials, as used through this library.
  """
  @spec headers_for(Pixiv.Credentials.t()) :: [{String.t(), String.t()}]
  def headers_for(%Pixiv.Credentials{access_token: token}) do
    [
      {"Authorization", "Bearer #{token}"} | headers()
    ]
  end
end
