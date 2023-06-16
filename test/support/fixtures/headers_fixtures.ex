defmodule Scadvert.HeadersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Scadvert.Headers` context.
  """

  @doc """
  Generate a header.
  """
  def header_fixture(attrs \\ %{}) do
    {:ok, header} =
      attrs
      |> Enum.into(%{
        code: 42,
        description: "some description",
        name: "some name",
        status: "some status"
      })
      |> Scadvert.Headers.create_header()

    header
  end
end
