defmodule Scadvert.LeadershipsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Scadvert.Leaderships` context.
  """

  @doc """
  Generate a leadership.
  """
  def leadership_fixture(attrs \\ %{}) do
    {:ok, leadership} =
      attrs
      |> Enum.into(%{
        code: 42,
        description: "some description",
        name: "some name",
        status: "some status"
      })
      |> Scadvert.Leaderships.create_leadership()

    leadership
  end
end
