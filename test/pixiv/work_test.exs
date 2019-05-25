defmodule Pixiv.WorkTest do
  use ExUnit.Case, async: true

  alias Pixiv.Authenticator
  alias Pixiv.Work

  setup_all do
    username = System.get_env("PIXIV_USERNAME")
    password = System.get_env("PIXIV_PASSWORD")

    %{
      credentials: Authenticator.login!(username, password)
    }
  end

  describe "Pixiv.Works.get/2" do
    setup [:prefetch]

    test "title is correct", %{gallery: gallery} do
      assert gallery["title"] == "星の語"
    end

    test "id is correct", %{gallery: gallery} do
      assert gallery["id"] == 54_032_421
    end
  end

  defp prefetch(context) do
    %{
      gallery: Work.get!(context.credentials, 54_032_421)
    }
  end
end
