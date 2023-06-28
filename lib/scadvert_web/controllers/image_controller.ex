defmodule ScadvertWeb.ImageController do
  use ScadvertWeb, :controller

  alias Scadvert.Images
  alias Scadvert.Images.Image
  alias Scadvert.Functions
  
  plug :put_layout, "newlayout.html"


  def index(conn, _params) do
    images = Images.list_images_by_user_id(conn)
    render(conn, "index.html", images: images)
  end

  def new(conn, _params) do
    changeset = Images.change_image(%Image{})

    codes = Functions.list_codes(conn)

    render(conn, "new.html", changeset: changeset, codes: codes)
  end

  def create(conn, %{"image" => image_params}) do
    image_params = Map.put(image_params, "user_id", conn.assigns.current_user.id)

    # codes = Functions.list_codes(conn)

    case Images.create_image(image_params) do
      {:ok, image} ->
        conn
        |> put_flash(:info, "Image created successfully.")
        |> redirect(to: Routes.image_path(conn, :show, image))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    image = Images.get_image!(id)
    render(conn, "show.html", image: image)
  end

  def edit(conn, %{"id" => id}) do
    image = Images.get_image!(id)
    changeset = Images.change_image(image)
    render(conn, "edit.html", image: image, changeset: changeset)
  end

  def update(conn, %{"id" => id, "image" => image_params}) do
    image = Images.get_image!(id)

    case Images.update_image(image, image_params) do
      {:ok, image} ->
        conn
        |> put_flash(:info, "Image updated successfully.")
        |> redirect(to: Routes.image_path(conn, :show, image))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", image: image, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    image = Images.get_image!(id)
    {:ok, _image} = Images.delete_image(image)

    conn
    |> put_flash(:info, "Image deleted successfully.")
    |> redirect(to: Routes.image_path(conn, :index))
  end
end
