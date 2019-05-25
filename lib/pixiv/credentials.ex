defmodule Pixiv.Credentials do
  @moduledoc """
  A struct to hold credential tokens from Pixiv.

  These consist of an access token, used to authenticate requests to the web API, a
  refresh token, used to request a new access token when it expires, as well the
  expiration timestamp itself for the token.

  Do note that accessing the expiration timestamp directly is considered undefined
  behaviour, and methods such as `expired?/1` or `expires_in/1` should be used instead.
  """

  alias Pixiv.Credentials

  @type t :: %Credentials{
          access_token: String.t(),
          refresh_token: String.t(),
          expires_at: integer
        }

  defstruct [:access_token, :refresh_token, :expires_at]

  @doc """
  Builds a `t:Pixiv.Credentials.t/0` from the given arguments.
  """
  @spec new(String.t(), String.t(), integer) :: Credentials.t()
  def new(access_token, refresh_token, expires_in) do
    %Credentials{
      access_token: access_token,
      refresh_token: refresh_token,
      expires_at: expires_in + time()
    }
  end

  @doc """
  Builds a `t:Pixiv.Credentials.t/0` from the given refresh token. The resulting
  credential is treated as expired by default.
  """
  @spec from_token(String.t()) :: Credentials.t()
  def from_token(refresh_token) do
    %Credentials{refresh_token: refresh_token}
  end

  @doc """
  Returns how many seconds are left until the token expires.
  """
  @spec expires_in(Credentials.t()) :: integer
  def expires_in(%Credentials{expires_at: expires_at}) do
    expires_at - time()
  end

  @doc """
  Returns whether a Pixiv.Credentials struct is expired.
  """
  @spec expired?(Credentials.t()) :: boolean
  def expired?(%Credentials{expires_at: expires_at} = credentials) do
    is_nil(expires_at) or expires_in(credentials) <= 0
  end

  defp time() do
    System.monotonic_time(:second)
  end
end
