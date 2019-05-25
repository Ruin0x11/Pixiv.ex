defmodule Pixiv.AuthenticatorTest do
  use ExUnit.Case, async: true

  alias Pixiv.Authenticator
  alias Pixiv.Credentials

  setup_all do
    %{
      username: System.get_env("PIXIV_USERNAME"),
      password: System.get_env("PIXIV_PASSWORD")
    }
  end

  test "login works", context do
    assert {:ok, credentials} = Authenticator.login(context.username, context.password)

    assert %Credentials{} = credentials
    refute Credentials.expired?(credentials)
  end

  test "invalid login" do
    assert {:error, _reason} = Authenticator.login("example@example.com", "example")
  end
end
