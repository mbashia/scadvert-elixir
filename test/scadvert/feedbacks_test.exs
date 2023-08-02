defmodule Scadvert.FeedbacksTest do
  use Scadvert.DataCase

  alias Scadvert.Feedbacks

  describe "feedbacks" do
    alias Scadvert.Feedbacks.Feedback

    import Scadvert.FeedbacksFixtures

    @invalid_attrs %{email: nil, message: nil, name: nil}

    test "list_feedbacks/0 returns all feedbacks" do
      feedback = feedback_fixture()
      assert Feedbacks.list_feedbacks() == [feedback]
    end

    test "get_feedback!/1 returns the feedback with given id" do
      feedback = feedback_fixture()
      assert Feedbacks.get_feedback!(feedback.id) == feedback
    end

    test "create_feedback/1 with valid data creates a feedback" do
      valid_attrs = %{email: "some email", message: "some message", name: "some name"}

      assert {:ok, %Feedback{} = feedback} = Feedbacks.create_feedback(valid_attrs)
      assert feedback.email == "some email"
      assert feedback.message == "some message"
      assert feedback.name == "some name"
    end

    test "create_feedback/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Feedbacks.create_feedback(@invalid_attrs)
    end

    test "update_feedback/2 with valid data updates the feedback" do
      feedback = feedback_fixture()
      update_attrs = %{email: "some updated email", message: "some updated message", name: "some updated name"}

      assert {:ok, %Feedback{} = feedback} = Feedbacks.update_feedback(feedback, update_attrs)
      assert feedback.email == "some updated email"
      assert feedback.message == "some updated message"
      assert feedback.name == "some updated name"
    end

    test "update_feedback/2 with invalid data returns error changeset" do
      feedback = feedback_fixture()
      assert {:error, %Ecto.Changeset{}} = Feedbacks.update_feedback(feedback, @invalid_attrs)
      assert feedback == Feedbacks.get_feedback!(feedback.id)
    end

    test "delete_feedback/1 deletes the feedback" do
      feedback = feedback_fixture()
      assert {:ok, %Feedback{}} = Feedbacks.delete_feedback(feedback)
      assert_raise Ecto.NoResultsError, fn -> Feedbacks.get_feedback!(feedback.id) end
    end

    test "change_feedback/1 returns a feedback changeset" do
      feedback = feedback_fixture()
      assert %Ecto.Changeset{} = Feedbacks.change_feedback(feedback)
    end
  end
end
