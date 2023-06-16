defmodule Scadvert.FeaturesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Scadvert.Features` context.
  """

  @doc """
  Generate a feature.
  """
  def feature_fixture(attrs \\ %{}) do
    {:ok, feature} =
      attrs
      |> Enum.into(%{
        code: 42,
        description: "some description",
        name: "some name",
        status: "some status"
      })
      |> Scadvert.Features.create_feature()

    feature
  end
end
