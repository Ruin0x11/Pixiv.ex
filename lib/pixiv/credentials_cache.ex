defmodule Pixiv.CredentialsCache do
  use GenServer
  alias Pixiv.Credentials

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @doc """
  Returns the credentials as currently stored.

  Note: this function will never do a refresh on its own, and thus credentials may
  be invalid.
  """
  def credentials() do
    GenServer.call(__MODULE__, :credentials)
  end

  def refresh(lazy \\ true) do
    GenServer.cast(__MODULE__, {:refresh, lazy})
  end

  # GenServer callbacks

  def init([]) do
    init(%{
      username: Application.get_env(:pixiv, :username),
      password: Application.get_env(:pixiv, :password)
    })
  end

  def init(%{username: username, password: password}) do
    case login(username, password) do
      {:ok, token} -> {:ok, token}
      {:error, reason} -> {:stop, reason}
    end
  end

  def handle_call(:credentials, _, state) do
    {:reply, state, state}
  end

  def handle_cast({:refresh, lazy}, state) do
    case refresh(state, lazy) do
      {:ok, state} -> {:noreply, state}
      {:noop, state} -> {:noreply, state}
      {:error, reason} -> {:stop, reason, %Credentials{}}
    end
  end

  # Utility functions

  defp login(username, password) do
    apply(Application.get_env(:pixiv, :authenticator), :login, [username, password])
  end

  defp refresh(credentials, lazy) do
    apply(Application.get_env(:pixiv, :authenticator), :refresh, [credentials, lazy])
  end
end
