defmodule Pixiv.CredentialsCache do
  @moduledoc """
  Storage mechanism for upkeeping credentials.
  """

  use GenServer

  alias Pixiv.Authenticator
  alias Pixiv.Credentials

  @doc """
  Starts a credentials server.
  """
  def start_link(options) do
    GenServer.start_link(__MODULE__, options, name: __MODULE__)
  end

  @doc """
  Gets the credentials as currently stored.

  Do note that this function will never do a refresh on its own, and as such
  may return stale values.
  """
  def credentials() do
    GenServer.call(__MODULE__, :credentials)
  end

  @doc """
  Refreshes the credentials.

  If `lazy` is set, nothing is done unless the access token is expired.
  """
  def refresh(lazy \\ true) do
    GenServer.cast(__MODULE__, {:refresh, lazy})
  end

  ## Callbacks

  @doc false
  def init(%Credentials{} = credentials) do
    case Authenticator.refresh(credentials, false) do
      {:ok, state} -> {:ok, state}
      {:error, reason} -> {:stop, reason}
    end
  end

  @doc false
  def init(options) do
    case Authenticator.login(options[:username], options[:password]) do
      {:ok, state} -> {:ok, state}
      {:error, reason} -> {:stop, reason}
    end
  end

  @doc false
  def handle_call(:credentials, _from, state) do
    {:reply, state, state}
  end

  @doc false
  def handle_cast({:refresh, lazy}, state) do
    case Authenticator.refresh(state, lazy) do
      {:ok, state} -> {:noreply, state}
      {:error, reason} -> {:stop, reason, %Credentials{}}
    end
  end
end
