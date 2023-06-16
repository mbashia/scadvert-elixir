defmodule ScadvertWeb.LeadershipControllerTest do
  use ScadvertWeb.ConnCase

  import Scadvert.LeadershipsFixtures

  @create_attrs %{code: 42, description: "some description", name: "some name", status: "some status"}
  @update_attrs %{code: 43, description: "some updated description", name: "some updated name", status: "some updated status"}
  @invalid_attrs %{code: nil, description: nil, name: nil, status: nil}

  describe "index" do
    test "lists all leaderships", %{conn: conn} do
      conn = get(conn, Routes.leadership_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Leaderships"
    end
  end

  describe "new leadership" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.leadership_path(conn, :new))
      assert html_response(conn, 200) =~ "New Leadership"
    end
  end

  describe "create leadership" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.leadership_path(conn, :create), leadership: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.leadership_path(conn, :show, id)

      conn = get(conn, Routes.leadership_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Leadership"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.leadership_path(conn, :create), leadership: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Leadership"
    end
  end

  describe "edit leadership" do
    setup [:create_leadership]

    test "renders form for editing chosen leadership", %{conn: conn, leadership: leadership} do
      conn = get(conn, Routes.leadership_path(conn, :edit, leadership))
      assert html_response(conn, 200) =~ "Edit Leadership"
    end
  end

  describe "update leadership" do
    setup [:create_leadership]

    test "redirects when data is valid", %{conn: conn, leadership: leadership} do
      conn = put(conn, Routes.leadership_path(conn, :update, leadership), leadership: @update_attrs)
      assert redirected_to(conn) == Routes.leadership_path(conn, :show, leadership)

      conn = get(conn, Routes.leadership_path(conn, :show, leadership))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, leadership: leadership} do
      conn = put(conn, Routes.leadership_path(conn, :update, leadership), leadership: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Leadership"
    end
  end

  describe "delete leadership" do
    setup [:create_leadership]

    test "deletes chosen leadership", %{conn: conn, leadership: leadership} do
      conn = delete(conn, Routes.leadership_path(conn, :delete, leadership))
      assert redirected_to(conn) == Routes.leadership_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.leadership_path(conn, :show, leadership))
      end
    end
  end

  defp create_leadership(_) do
    leadership = leadership_fixture()
    %{leadership: leadership}
  end
end
