defmodule Scadvert.CodesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Scadvert.Codes` context.
  """

  @doc """
  Generate a code.
  """
  def code_fixture(attrs \\ %{}) do
    {:ok, code} =
      attrs
      |> Enum.into(%{
        active: "some active",
        description: "some description",
        name: 42
      })
      |> Scadvert.Codes.create_code()

    code
  end
end
