defmodule Scadvert.FacilitysFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Scadvert.Facilitys` context.
  """

  @doc """
  Generate a facility.
  """
  def facility_fixture(attrs \\ %{}) do
    {:ok, facility} =
      attrs
      |> Enum.into(%{
        active: "some active",
        code: 42,
        description: "some description",
        name: "some name"
      })
      |> Scadvert.Facilitys.create_facility()

    facility
  end
end
