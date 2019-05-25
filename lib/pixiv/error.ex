defmodule Pixiv.Error do
  @moduledoc """
  The base exception common through the library.

  This should only occur when using the banged methods.
  """

  defexception [:message]
end
