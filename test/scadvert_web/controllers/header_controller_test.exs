defmodule ScadvertWeb.HeaderControllerTest do
  use ScadvertWeb.ConnCase

  import Scadvert.HeadersFixtures

  @create_attrs %{
    code: 42,
    description: "some description",
    name: "some name",
    status: "some status"
  }
  @update_attrs %{
    code: 43,
    description: "some updated description",
    name: "some updated name",
    status: "some updated status"
  }
  @invalid_attrs %{code: nil, description: nil, name: nil, status: nil}

  describe "index" do
    test "lists all headers", %{conn: conn} do
      conn = get(conn, Routes.header_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Headers"
    end
  end

  describe "new header" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.header_path(conn, :new))
      assert html_response(conn, 200) =~ "New Header"
    end
  end

  describe "create header" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.header_path(conn, :create), header: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.header_path(conn, :show, id)

      conn = get(conn, Routes.header_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Header"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.header_path(conn, :create), header: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Header"
    end
  end

  describe "edit header" do
    setup [:create_header]

    test "renders form for editing chosen header", %{conn: conn, header: header} do
      conn = get(conn, Routes.header_path(conn, :edit, header))
      assert html_response(conn, 200) =~ "Edit Header"
    end
  end

  describe "update header" do
    setup [:create_header]

    test "redirects when data is valid", %{conn: conn, header: header} do
      conn = put(conn, Routes.header_path(conn, :update, header), header: @update_attrs)
      assert redirected_to(conn) == Routes.header_path(conn, :show, header)

      conn = get(conn, Routes.header_path(conn, :show, header))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, header: header} do
      conn = put(conn, Routes.header_path(conn, :update, header), header: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Header"
    end
  end

  describe "delete header" do
    setup [:create_header]

    test "deletes chosen header", %{conn: conn, header: header} do
      conn = delete(conn, Routes.header_path(conn, :delete, header))
      assert redirected_to(conn) == Routes.header_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.header_path(conn, :show, header))
      end
    end
  end

  defp create_header(_) do
    header = header_fixture()
    %{header: header}
  end
end
