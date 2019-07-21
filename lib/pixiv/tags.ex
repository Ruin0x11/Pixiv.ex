defmodule Pixiv.Tags do
  @moduledoc """
  Utility module for fetching tag translations from Pixiv.
  """

  @typedoc "A map of translations"
  @type translations :: %{String.t() => term}

  require Pixiv.Utils

  @doc """
  Requests the gallery tag map for the given `id`.
  """
  @spec get_work_tags(term) :: {:ok, translations} | :error
  def get_work_tags(id) do
    with {:ok, work} <- get_work_metadata(id) do
      case get_in(work, ["tags", "tags"]) do
        nil -> :error
        tags -> {:ok, index_tags(tags)}
      end
    end
  end

  @doc """
  Same as `get_work_tags/1`, but raises `Pixiv.Error` on failure.
  """
  @spec get_work_tags!(term) :: translations
  def get_work_tags!(id) do
    Pixiv.Utils.bangify(get_work_tags(id))
  end

  @doc """
  Translates `name`, using `terms` as a dictionary.

  Returns `nil` if no result was found.
  """
  @spec translate(translations, String.t()) :: String.t() | nil
  def translate(terms, name) do
    get_in(terms, [name, "translation", "en"])
  end

  # Gets and decodes the gallery data for the given `id`.
  defp get_work_metadata(id) do
    with {:ok, response} <- HTTPoison.get("https://www.pixiv.net/ajax/illust/#{id}"),
         {:ok, response} <- Jason.decode(response.body) do
      Map.fetch(response, "body")
    end
  end

  # Indexes tags by their Japanese name.
  defp index_tags(table) do
    for row <- table, do: {row["tag"], row}, into: %{}
  end
end
