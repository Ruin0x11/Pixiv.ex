defmodule Pixiv.Works do
  @moduledoc """
  """

  alias Pixiv.API

  @doc """
  Fetches metadata for a single gallery.
  """
  def fetch(work_id, options \\ []) do
    with {:ok, response} <- API.get("/works/#{work_id}", [], options),
         %{status_code: 200, body: body} <- response,
         %{"response" => [work | _]} <- body do
      {:ok, work}
    else
      {:error, _reason} = error ->
        error

      %{status_code: status_code} ->
        {:error, "HTTP request returned code #{status_code}."}

      _ ->
        {:error, "Unknown error."}
    end
  end

  @doc """
  Naively parses and returns the updated date for a gallery.
  """
  def updated_at(work) do
    work
    |> Map.get("reuploaded_time", work["created_time"])
    |> NaiveDateTime.from_iso8601!()
  end

  def animated?(work) do
    work["type"] == "ugoira"
  end

  def multipage?(work) do
    work["page_count"] > 1
  end

  def link(work) do
    "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=#{work["id"]}"
  end

  def author_link(work) do
    "https://www.pixiv.net/member.php?id=#{work["user"]["id"]}"
  end
end
