defmodule Pixiv do
  def base_url, do: "https://public-api.secure.pixiv.net/v1"
  def auth_url, do: "https://oauth.secure.pixiv.net/auth/token"

  def client_id, do: "MOBrBDS8blbauoSck0ZfDbtuzpyT"
  def client_secret, do: "lsACyCD94FhDUtGTXi3QzcFE2uU1hqtDaKeqrdwj"

  def headers() do
    [
      {"User-Agent", "PixivAndroidApp/5.0.64 (Android 6.0)"},
      {"Referer", "https://public-api.secure.pixiv.net/"}
    ]
  end

  def headers(%Pixiv.Credentials{access_token: token}) do
    [
      {"Authorization", "Bearer #{token}"} | headers()
    ]
  end
end
