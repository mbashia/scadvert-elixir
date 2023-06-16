defmodule Scadvert.ImagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Scadvert.Images` context.
  """

  @doc """
  Generate a image.
  """
  def image_fixture(attrs \\ %{}) do
    {:ok, image} =
      attrs
      |> Enum.into(%{
        code: 42,
        description: "some description",
        name: "some name",
        status: "some status"
      })
      |> Scadvert.Images.create_image()

    image
  end
end
