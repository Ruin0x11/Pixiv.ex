defmodule Pixiv.WorksTest do
  use ExUnit.Case

  alias Pixiv.Works, as: Subject

  doctest Subject

  setup_all do
    start_supervised!(Pixiv.credentials_cache())

    :ok
  end

  describe "Pixiv.Works.fetch/2" do
    setup [:fetch_work]

    test "title is correct", context do
      assert context["title"] == "星の語"
    end

    test "id is correct", context do
      assert context["id"] == 54_032_421
    end
  end

  defp fetch_work(_context) do
    Subject.fetch!(54_032_421)
  end
end
