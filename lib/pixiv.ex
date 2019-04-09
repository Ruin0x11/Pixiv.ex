defmodule Pixiv do
  def base_url, do: "https://public-api.secure.pixiv.net/v1"
  def auth_url, do: "https://oauth.secure.pixiv.net/auth/token"

  def client_id, do: "MOBrBDS8blbauoSck0ZfDbtuzpyT"
  def client_secret, do: "lsACyCD94FhDUtGTXi3QzcFE2uU1hqtDaKeqrdwj"

  @doc """
  Returns the configured `:username` entry.
  """
  def username do
    Application.get_env(:pixiv, :username)
  end

  @doc """
  Returns the configured `:password` entry.
  """
  def password do
    Application.get_env(:pixiv, :password)
  end

  @doc """
  Returns the configured `:authenticator` entry.

  If not supplied, `Pixiv.Authenticator` is used by default.
  """
  def authenticator do
    Application.get_env(:pixiv, :authenticator, Pixiv.Authenticator)
  end

  @doc """
  Returns the configured `:credentials_cache` entry.

  If not supplied, `Pixiv.CredentialsCache` is used by default.
  """
  def credentials_cache do
    Application.get_env(:pixiv, :credentials_cache, Pixiv.CredentialsCache)
  end

  @doc """
  Returns the headers as used through this library.
  """
  def headers() do
    [
      {"User-Agent", "PixivAndroidApp/5.0.64 (Android 6.0)"},
      {"Referer", "https://public-api.secure.pixiv.net/"}
    ]
  end

  @doc """
  Returns the headers, bound to credentials, as used through this library.
  """
  def headers(%Pixiv.Credentials{access_token: token}) do
    [
      {"Authorization", "Bearer #{token}"} | headers()
    ]
  end
end
