defmodule ScadvertWeb.ImageController do
  use ScadvertWeb, :controller
  alias Scadvert.Repo
  import Ecto.Query, warn: false
  alias Scadvert.Images
  alias Scadvert.Images.Image
  alias Scadvert.Functions
  alias Scadvert.User_auth

  plug :put_layout, "newlayout.html"
  @default_image :"/images/phoenix.png"

  def index(conn, params) do
    if conn.assigns.current_user.role == "admin" do
      changeset = Images.change_image(%Image{})

      page = Images.list_all_images
                |>Repo.paginate(params)
      render(conn, "index.html", images: page.entries, default_image: @default_image, page: page, changeset: changeset, total_pages: page.total_pages)
    else
      changeset = Images.change_image(%Image{})

    page = Images.list_images_by_user_id(conn)
                    |>Repo.paginate(params)
    render(conn, "index.html", images: page.entries, default_image: @default_image, page: page, changeset: changeset, total_pages: page.total_pages)
    end
  end

  def new(conn, _params) do
    changeset = Images.change_image(%Image{})

    codes = Functions.list_codes(conn)

    render(conn, "new.html", changeset: changeset, codes: codes)
    IO.inspect User_auth.fetch_current_user(conn)

  end

  def create(conn, %{"image" => image_params}) do
    image_params = Map.put(image_params, "user_id", conn.assigns.current_user.id)

    codes = Functions.list_codes(conn)

    case Images.create_image(image_params) do
      {:ok, image} ->
        conn
        |> put_flash(:info, "Image created successfully.")
        |> redirect(to: Routes.image_path(conn, :show, image))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, codes: codes)
    end
  end

  def show(conn, %{"id" => id}) do
    image = Images.get_image!(id)
    render(conn, "show.html", image: image, default_image: @default_image)
  end

  def edit(conn, %{"id" => id}) do
    image = Images.get_image!(id)
    changeset = Images.change_image(image)
    codes = Functions.list_codes(conn)

    render(conn, "edit.html", image: image, changeset: changeset, codes: codes)
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
  def search(conn, %{"image" => %{"search" => search_params}}) do
    changeset = Images.change_image(%Image{})
    page = search_params(conn,search_params)
                     |>Repo.paginate(conn.params)
  case page.entries do
  [] ->
  conn
  |> put_flash(:error, "no results")
  |> render( "index.html", images: [], changeset: changeset, page: page, total_pages: page.total_pages)
  _ ->
  conn

  |> put_flash(:info, "image searched successfully.")

  |> render( "index.html", images: page.entries, changeset: changeset, page: page, default_image: @default_image, total_pages: page.total_pages)

  end

  end
  defp search_params(conn,params)do
    params = cond do
      params=="active" ->
      "true"
      params =="inactive" ->
        "false"
      true ->
        params

      end

    user= conn.assigns.current_user
    if user.role == "admin" do
      from(i in Image,
    join: c in assoc(i, :codes),
    where: fragment("? LIKE ?", c.name, ^"%#{params}%") or fragment("? LIKE ?", i.name, ^"%#{params}%") or fragment("? LIKE ?", i.description, ^"%#{params}%") or fragment("? LIKE ?", i.status, ^"%#{params}%") ,
    preload: [:codes])
    else
    from(i in Image,
    join: c in assoc(i, :codes),
    where: fragment("? LIKE ?", c.name, ^"%#{params}%") or fragment("? LIKE ?", i.name, ^"%#{params}%") or fragment("? LIKE ?", i.description, ^"%#{params}%") or fragment("? LIKE ?", i.status, ^"%#{params}%"), where: i.user_id == ^user.id,
    preload: [:codes])

    end

  end


end
