defmodule Pixiv.Utils do
  @doc """
  Extracts the `value` from a `{:ok, value}` expression, or raises an exception with
  `reason` if it's in the `{:error, reason}` format.
  """
  defmacro bangify(expr) do
    quote do
      case unquote(expr) do
        {:ok, value} -> value
        {:error, reason} -> raise Pixiv.Error, message: reason
      end
    end
  end
end
