defmodule Scadvert.VideosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Scadvert.Videos` context.
  """

  @doc """
  Generate a video.
  """
  def video_fixture(attrs \\ %{}) do
    {:ok, video} =
      attrs
      |> Enum.into(%{
        code: 42,
        description: "some description",
        name: "some name",
        status: "some status"
      })
      |> Scadvert.Videos.create_video()

    video
  end
end
