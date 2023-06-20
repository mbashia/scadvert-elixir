defmodule ScadvertWeb.HeaderController do
  use ScadvertWeb, :controller

  alias Scadvert.Headers
  alias Scadvert.Headers.Header
  alias Scadvert.Functions

  def index(conn, _params) do
    headers = Headers.list_headers()
    render(conn, "index.html", headers: headers)
  end

  def new(conn, _params) do
    changeset = Headers.change_header(%Header{})
    codes = Functions.list_codes(conn)

    render(conn, "new.html", changeset: changeset, codes: codes)


  end

  def create(conn, %{"header" => header_params}) do
    header_params = Map.put(header_params, "user_id", conn.assigns.current_user.id)

    case Headers.create_header(header_params) do
      {:ok, header} ->
        conn
        |> put_flash(:info, "Header created successfully.")
        |> redirect(to: Routes.header_path(conn, :show, header))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    header = Headers.get_header!(id)
    render(conn, "show.html", header: header)
  end

  def edit(conn, %{"id" => id}) do
    header = Headers.get_header!(id)
    changeset = Headers.change_header(header)
    render(conn, "edit.html", header: header, changeset: changeset)
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
