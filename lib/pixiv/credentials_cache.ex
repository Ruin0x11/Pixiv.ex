defmodule Pixiv.CredentialsCache do
  @moduledoc """
  Basic mechanism for storage and upkeeping of credentials.

  If no authentication information is supplied at the start, this module will
  look for `:username` and `:password` under the `:pixiv` application config.
  """

  use GenServer

  alias Pixiv.Credentials

  @doc """
  Starts a credentials server.
  """
  def start_link(config) do
    GenServer.start_link(__MODULE__, config, name: __MODULE__)
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

  If lazy is `true`, a refresh request won't be made unless needed.
  """
  def refresh(lazy \\ true) do
    GenServer.cast(__MODULE__, {:refresh, lazy})
  end

  ## Callbacks

  @doc false
  def init([]) do
    init(username: Pixiv.username(), password: Pixiv.password())
  end

  @doc false
  def init(%Credentials{} = credentials) do
    case refresh(credentials, false) do
      {:ok, state} -> {:ok, state}
      {:error, reason} -> {:stop, reason}
    end
  end

  @doc false
  def init(username: username, password: password) do
    case login(username, password) do
      {:ok, state} -> {:ok, state}
      {:error, reason} -> {:stop, reason}
    end
  end

  @doc false
  def handle_call(:credentials, _, state) do
    {:reply, state, state}
  end

  @doc false
  def handle_cast({:refresh, lazy}, state) do
    case refresh(state, lazy) do
      {:ok, state} -> {:noreply, state}
      {:noop, state} -> {:noreply, state}
      {:error, reason} -> {:stop, reason, %Credentials{}}
    end
  end

  ## Utility functions

  defp login(username, password) do
    Pixiv.authenticator().login(username, password)
  end

  defp refresh(credentials, lazy) do
    Pixiv.authenticator().refresh(credentials, lazy)
  end
end
