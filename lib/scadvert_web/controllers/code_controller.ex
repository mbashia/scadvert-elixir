defmodule ScadvertWeb.CodeController do
  use ScadvertWeb, :controller

  alias Scadvert.Codes
  alias Scadvert.Codes.Code

  def index(conn, _params) do
    codes = Codes.list_codes()
    render(conn, "index.html", codes: codes)
  end

  def new(conn, _params) do
    changeset = Codes.change_code(%Code{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"code" => code_params}) do
    case Codes.create_code(code_params) do
      {:ok, code} ->
        conn
        |> put_flash(:info, "Code created successfully.")
        |> redirect(to: Routes.code_path(conn, :show, code))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    code = Codes.get_code!(id)
    render(conn, "show.html", code: code)
  end

  def edit(conn, %{"id" => id}) do
    code = Codes.get_code!(id)
    changeset = Codes.change_code(code)
    render(conn, "edit.html", code: code, changeset: changeset)
  end

  def update(conn, %{"id" => id, "code" => code_params}) do
    code = Codes.get_code!(id)

    case Codes.update_code(code, code_params) do
      {:ok, code} ->
        conn
        |> put_flash(:info, "Code updated successfully.")
        |> redirect(to: Routes.code_path(conn, :show, code))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", code: code, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    code = Codes.get_code!(id)
    {:ok, _code} = Codes.delete_code(code)

    conn
    |> put_flash(:info, "Code deleted successfully.")
    |> redirect(to: Routes.code_path(conn, :index))
  end
end
