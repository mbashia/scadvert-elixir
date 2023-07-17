defmodule ScadvertWeb.HeaderController do
  use ScadvertWeb, :controller
  alias Scadvert.Repo
  import Ecto.Query, warn: false


  alias Scadvert.Headers
  alias Scadvert.Headers.Header
  alias Scadvert.Functions

  plug :put_layout, "newlayout.html"

  @default_image :"/images/phoenix.png"

  def index(conn, params) do
    if conn.assigns.current_user.role ==  "admin" do
      changeset = Headers.change_header(%Header{})

      page = Headers.list_all_headers
                    |>Repo.paginate(params)
      render(conn, "index.html", headers: page.entries, default_image: @default_image, page: page, changeset: changeset)
    else
      changeset = Headers.change_header(%Header{})

    page = Headers.list_headers_by_user_id(conn)
                              |>Repo.paginate(params)
    render(conn, "index.html", changeset: changeset, headers: page.entries, default_image: @default_image, page: page)
    end

  end

  def new(conn, _params) do
    changeset = Headers.change_header(%Header{})
    codes = Functions.list_codes(conn)

    render(conn, "new.html", changeset: changeset, codes: codes, default_image: @default_image)
  end

  def create(conn, %{"header" => header_params}) do
    header_params = Map.put(header_params, "user_id", conn.assigns.current_user.id)
    codes = Functions.list_codes(conn)

    case Headers.create_header(header_params) do
      {:ok, header} ->
        conn
        |> put_flash(:info, "Header created successfully.")
        |> redirect(to: Routes.header_path(conn, :show, header))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, codes: codes)
    end
  end

  def show(conn, %{"id" => id}) do
    header = Headers.get_header!(id)
    render(conn, "show.html", header: header, default_image: @default_image)
  end

  def edit(conn, %{"id" => id}) do
    header = Headers.get_header!(id)
    changeset = Headers.change_header(header)
    codes = Functions.list_codes(conn)
    render(conn, "edit.html", header: header, changeset: changeset, codes: codes)
  end

  def update(conn, %{"id" => id, "header" => header_params}) do
    header = Headers.get_header!(id)

    case Headers.update_header(header, header_params) do
      {:ok, header} ->
        conn
        |> put_flash(:info, "Header updated successfully.")
        |> redirect(to: Routes.header_path(conn, :show, header))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", header: header, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    header = Headers.get_header!(id)
    {:ok, _header} = Headers.delete_header(header)

    conn
    |> put_flash(:info, "Header deleted successfully.")
    |> redirect(to: Routes.header_path(conn, :index))
  end
  def search(conn, %{"header" => %{"search" => search_params}}) do
    changeset = Headers.change_header(%Header{})
    page = search_params(conn,search_params)
                     |>Repo.paginate(conn.params)
  case page.entries do
  [] ->
  conn
  |> put_flash(:error, "no results")
  |> render( "index.html", headers: [], changeset: changeset, page: page)
  _ ->
  conn

  |> put_flash(:info, "Header searched successfully.")

  |> render( "index.html", headers: page.entries, changeset: changeset, page: page, default_image: @default_image)

  end

  end
  defp search_params(conn,params)do
    user_id = conn.assigns.current_user.id
   from(h in Header,
   join: c in assoc(h, :codes),
   where: fragment("? LIKE ?", c.name, ^"%#{params}%")  and h.user_id == ^user_id,
   preload: [:codes])



  end
end
