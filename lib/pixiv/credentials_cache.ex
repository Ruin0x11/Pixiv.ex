defmodule Pixiv.CredentialsCache do
  @moduledoc """
  Storage mechanism for upkeeping credentials.
  """

  use Agent

  alias Pixiv.Authenticator
  alias Pixiv.Credentials

  @agent __MODULE__

  @doc """
  Starts a credentials server.
  """
  def start_link(options)

  def start_link(credentials) when is_list(credentials) do
    start_link(%{
      username: credentials[:username],
      password: credentials[:password]
    })
  end

  def start_link(%{username: username, password: password}) do
    start_link(Authenticator.login!(username, password))
  end

  def start_link(%Credentials{} = credentials) do
    Agent.start_link(fn -> credentials end, name: @agent)
  end

  @doc """
  Gets the credentials as currently stored.

  Do note that this function will never do a refresh on its own, and as such
  may return stale values.
  """
  @spec credentials() :: Credentials.t()
  def credentials do
    Agent.get(@agent, & &1)
  end

  @doc """
  Gets the stored credentials, refreshing them if they're expired.
  """
  def refresh_and_get do
    Agent.get_and_update(@agent, fn credentials ->
      credentials = Authenticator.refresh!(credentials)
      {credentials, credentials}
    end)
  end

  @doc """
  Refreshes the credentials.

  If `lazy` is set, nothing is done unless the access token is expired.
  """
  def refresh(lazy \\ true) do
    Agent.cast(@agent, fn credentials ->
      Authenticator.refresh!(credentials, lazy)
    end)
  end
end
