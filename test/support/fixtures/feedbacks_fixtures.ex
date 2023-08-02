defmodule Scadvert.FeedbacksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Scadvert.Feedbacks` context.
  """

  @doc """
  Generate a feedback.
  """
  def feedback_fixture(attrs \\ %{}) do
    {:ok, feedback} =
      attrs
      |> Enum.into(%{
        email: "some email",
        message: "some message",
        name: "some name"
      })
      |> Scadvert.Feedbacks.create_feedback()

    feedback
  end
end
