defmodule Pixiv.TagsTest do
  use ExUnit.Case, async: true

  alias Pixiv.Tags

  setup do
    %{tags: Tags.get_work_tags!(54_032_421)}
  end

  test "translation is correct", %{tags: tags} do
    assert Tags.translate(tags, "女の子") == "girl"
    assert is_nil(Tags.translate(tags, "missing"))
  end
end
