defmodule ScadvertWeb.ImageControllerTest do
  use ScadvertWeb.ConnCase

  import Scadvert.ImagesFixtures

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
    test "lists all images", %{conn: conn} do
      conn = get(conn, Routes.image_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Images"
    end
  end

  describe "new image" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.image_path(conn, :new))
      assert html_response(conn, 200) =~ "New Image"
    end
  end

  describe "create image" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.image_path(conn, :create), image: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.image_path(conn, :show, id)

      conn = get(conn, Routes.image_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Image"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.image_path(conn, :create), image: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Image"
    end
  end

  describe "edit image" do
    setup [:create_image]

    test "renders form for editing chosen image", %{conn: conn, image: image} do
      conn = get(conn, Routes.image_path(conn, :edit, image))
      assert html_response(conn, 200) =~ "Edit Image"
    end
  end

  describe "update image" do
    setup [:create_image]

    test "redirects when data is valid", %{conn: conn, image: image} do
      conn = put(conn, Routes.image_path(conn, :update, image), image: @update_attrs)
      assert redirected_to(conn) == Routes.image_path(conn, :show, image)

      conn = get(conn, Routes.image_path(conn, :show, image))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, image: image} do
      conn = put(conn, Routes.image_path(conn, :update, image), image: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Image"
    end
  end

  describe "delete image" do
    setup [:create_image]

    test "deletes chosen image", %{conn: conn, image: image} do
      conn = delete(conn, Routes.image_path(conn, :delete, image))
      assert redirected_to(conn) == Routes.image_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.image_path(conn, :show, image))
      end
    end
  end

  defp create_image(_) do
    image = image_fixture()
    %{image: image}
  end
end
