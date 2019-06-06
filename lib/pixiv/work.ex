defmodule Pixiv.Work do
  @moduledoc """
  Endpoints for retrieving information about a gallery.
  """

  alias Pixiv.Client
  alias Pixiv.Credentials
  alias Pixiv.Utils

  require Pixiv.Utils

  @doc """
  Fetches metadata for a single gallery.
  """
  def get(credentials, id, options \\ []) do
    case Client.get(credentials, "/works/#{id}", options) do
      {:ok, %{status_code: 200} = response} ->
        process_response(response)

      {:ok, %{status_code: status_code}} ->
        {:error, "HTTP request returned code `#{status_code}`."}

      {:error, reason} ->
        {:error, reason}

      _ ->
        {:error, "Unknown error."}
    end
  end

  defp process_response(response) do
    if %{"response" => [work]} = response.body do
      {:ok, work}
    else
      {:error, "Unexpected response body."}
    end
  end

  @doc """
  Fetches metadata for a single gallery.
  """
  @spec get!(Credentials.t(), integer, Keyword.t()) :: term
  def get!(credentials, id, options \\ []) do
    Utils.bangify(get(credentials, id, options))
  end

  @doc """
  Naively parses and returns the updated date for a gallery.
  """
  @spec updated_at!(term) :: NaiveDateTime.t()
  def updated_at!(gallery) do
    gallery
    |> Map.get("reuploaded_time", gallery["created_time"])
    |> NaiveDateTime.from_iso8601!()
  end

  @doc """
  Whether the given gallery is animated.
  """
  @spec animated?(term) :: boolean
  def animated?(gallery) do
    gallery["type"] == "ugoira"
  end

  @doc """
  Whether the given gallery has more than one page.
  """
  @spec multipage?(term) :: boolean
  def multipage?(gallery) do
    gallery["page_count"] > 1
  end

  @doc """
  Returns a link to the Pixiv page for the given gallery.
  """
  @spec link_for(term) :: String.t()
  def link_for(gallery) do
    "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=#{gallery["id"]}"
  end

  @doc """
  Returns a link to the Pixiv page for the given gallery's author.
  """
  @spec author_link_for(term) :: String.t()
  def author_link_for(work) do
    "https://www.pixiv.net/member.php?id=#{work["user"]["id"]}"
  end
end
