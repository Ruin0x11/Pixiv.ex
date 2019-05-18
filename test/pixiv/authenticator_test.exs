defmodule Pixiv.AuthenticatorTest do
  use ExUnit.Case

  alias Pixiv.{Authenticator, Credentials}

  doctest Authenticator

  setup do
    {:ok, username: Pixiv.username(), password: Pixiv.password()}
  end

  test "login works", context do
    assert {:ok, credentials} = Authenticator.login(context.username, context.password)

    assert %Credentials{} = credentials
    refute Credentials.expired?(credentials)
  end

  test "invalid login" do
    assert Pixiv.Authenticator.login("example@example.com", "example") ==
             {:error, "Unauthorized! Maybe your pixiv username or password is wrong?"}
  end
end
