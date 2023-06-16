defmodule ScadvertWeb.CodeControllerTest do
  use ScadvertWeb.ConnCase

  import Scadvert.CodesFixtures

  @create_attrs %{active: "some active", description: "some description", name: 42}
  @update_attrs %{
    active: "some updated active",
    description: "some updated description",
    name: 43
  }
  @invalid_attrs %{active: nil, description: nil, name: nil}

  describe "index" do
    test "lists all codes", %{conn: conn} do
      conn = get(conn, Routes.code_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Codes"
    end
  end

  describe "new code" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.code_path(conn, :new))
      assert html_response(conn, 200) =~ "New Code"
    end
  end

  describe "create code" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.code_path(conn, :create), code: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.code_path(conn, :show, id)

      conn = get(conn, Routes.code_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Code"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.code_path(conn, :create), code: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Code"
    end
  end

  describe "edit code" do
    setup [:create_code]

    test "renders form for editing chosen code", %{conn: conn, code: code} do
      conn = get(conn, Routes.code_path(conn, :edit, code))
      assert html_response(conn, 200) =~ "Edit Code"
    end
  end

  describe "update code" do
    setup [:create_code]

    test "redirects when data is valid", %{conn: conn, code: code} do
      conn = put(conn, Routes.code_path(conn, :update, code), code: @update_attrs)
      assert redirected_to(conn) == Routes.code_path(conn, :show, code)

      conn = get(conn, Routes.code_path(conn, :show, code))
      assert html_response(conn, 200) =~ "some updated active"
    end

    test "renders errors when data is invalid", %{conn: conn, code: code} do
      conn = put(conn, Routes.code_path(conn, :update, code), code: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Code"
    end
  end

  describe "delete code" do
    setup [:create_code]

    test "deletes chosen code", %{conn: conn, code: code} do
      conn = delete(conn, Routes.code_path(conn, :delete, code))
      assert redirected_to(conn) == Routes.code_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.code_path(conn, :show, code))
      end
    end
  end

  defp create_code(_) do
    code = code_fixture()
    %{code: code}
  end
end
