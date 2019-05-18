defmodule Pixiv.Credentials do
  @moduledoc """
  Container for credential tokens from Pixiv.
  """

  defstruct ~w(access_token refresh_token expires_at)a

  @doc """
  Returns a Pixiv.Credentials struct for the given arguments.
  """
  def new(access_token, refresh_token, expires_in) when is_number(expires_in) do
    %__MODULE__{
      access_token: access_token,
      refresh_token: refresh_token,
      expires_at: expires_in + time()
    }
  end

  @doc """
  Returns whether a Pixiv.Credentials struct is expired.
  """
  def expired?(%__MODULE__{expires_at: expires_at}) do
    is_nil(expires_at) or expires_at <= time()
  end

  defp time() do
    System.monotonic_time(:second)
  end
end
