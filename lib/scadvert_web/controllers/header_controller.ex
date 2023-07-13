defmodule ScadvertWeb.HeaderController do
  use ScadvertWeb, :controller

  alias Scadvert.Headers
  alias Scadvert.Headers.Header
  alias Scadvert.Functions

  plug :put_layout, "newlayout.html"

  @default_image :"/images/phoenix.png"

  def index(conn, _params) do
    if conn.assigns.current_user.email in ["vic@gmail.com","john@gmail.com"] do
      headers = Headers.list_all_headers()
      render(conn, "index.html", headers: headers, default_image: @default_image)
    else
    headers = Headers.list_headers_by_user_id(conn)
    render(conn, "index.html", headers: headers, default_image: @default_image)
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
end
