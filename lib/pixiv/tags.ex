defmodule Pixiv.Tags do
  @moduledoc """
  Utility module for fetching tag translations from Pixiv.
  """

  @typedoc "A map of translations"
  @type translations :: %{String.t() => term}

  require Pixiv.Utils

  @doc """
  Requests the gallery tag index for the given `id`.
  """
  @spec get_work_tags(term, translations) :: translations | nil
  def get_work_tags(id, default \\ nil) do
    case get_work_metadata(id) do
      {:ok, %{"tags" => %{"tags" => tags}}} ->
        index_tags(tags)

      _ ->
        default
    end
  end

  @doc """
  Requests the gallery tag index for the given `id`, returning an error if it fails.
  """
  @spec fetch_work_tags(term) :: {:ok, translations} | :error
  def fetch_work_tags(id) do
    case get_work_tags(id) do
      nil -> :error
      index -> {:ok, index}
    end
  end

  @doc """
  Same as `fetch_work_tags/1`, but raises `Pixiv.Error` on failure.
  """
  @spec fetch_work_tags!(term) :: translations
  def fetch_work_tags!(id) do
    Pixiv.Utils.bangify(fetch_work_tags(id))
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
    with {:ok, response} <-
           HTTPoison.get("https://www.pixiv.net/ajax/illust/#{id}", Pixiv.headers()),
         {:ok, response} <- Jason.decode(response.body) do
      Map.fetch(response, "body")
    end
  end

  # Indexes tags by their Japanese name.
  defp index_tags(table) do
    for row <- table, do: {row["tag"], row}, into: %{}
  end
end
