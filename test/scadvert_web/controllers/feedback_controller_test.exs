defmodule ScadvertWeb.FeedbackControllerTest do
  use ScadvertWeb.ConnCase

  import Scadvert.FeedbacksFixtures

  @create_attrs %{email: "some email", message: "some message", name: "some name"}
  @update_attrs %{email: "some updated email", message: "some updated message", name: "some updated name"}
  @invalid_attrs %{email: nil, message: nil, name: nil}

  describe "index" do
    test "lists all feedbacks", %{conn: conn} do
      conn = get(conn, Routes.feedback_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Feedbacks"
    end
  end

  describe "new feedback" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.feedback_path(conn, :new))
      assert html_response(conn, 200) =~ "New Feedback"
    end
  end

  describe "create feedback" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.feedback_path(conn, :create), feedback: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.feedback_path(conn, :show, id)

      conn = get(conn, Routes.feedback_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Feedback"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.feedback_path(conn, :create), feedback: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Feedback"
    end
  end

  describe "edit feedback" do
    setup [:create_feedback]

    test "renders form for editing chosen feedback", %{conn: conn, feedback: feedback} do
      conn = get(conn, Routes.feedback_path(conn, :edit, feedback))
      assert html_response(conn, 200) =~ "Edit Feedback"
    end
  end

  describe "update feedback" do
    setup [:create_feedback]

    test "redirects when data is valid", %{conn: conn, feedback: feedback} do
      conn = put(conn, Routes.feedback_path(conn, :update, feedback), feedback: @update_attrs)
      assert redirected_to(conn) == Routes.feedback_path(conn, :show, feedback)

      conn = get(conn, Routes.feedback_path(conn, :show, feedback))
      assert html_response(conn, 200) =~ "some updated email"
    end

    test "renders errors when data is invalid", %{conn: conn, feedback: feedback} do
      conn = put(conn, Routes.feedback_path(conn, :update, feedback), feedback: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Feedback"
    end
  end

  describe "delete feedback" do
    setup [:create_feedback]

    test "deletes chosen feedback", %{conn: conn, feedback: feedback} do
      conn = delete(conn, Routes.feedback_path(conn, :delete, feedback))
      assert redirected_to(conn) == Routes.feedback_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.feedback_path(conn, :show, feedback))
      end
    end
  end

  defp create_feedback(_) do
    feedback = feedback_fixture()
    %{feedback: feedback}
  end
end
