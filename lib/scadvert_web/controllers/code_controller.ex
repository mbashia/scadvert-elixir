defmodule ScadvertWeb.CodeController do
  use ScadvertWeb, :controller

  alias Scadvert.Codes
  alias Scadvert.Codes.Code
  alias Scadvert.Repo

  import Ecto.Query, warn: false


  plug :put_layout, "newlayout.html"
  @default_image :"/images/phoenix.png"


  def index(conn, params) do
    if conn.assigns.current_user.email in ["vic@gmail.com","john@gmail.com"] do
      changeset = Codes.change_code(%Code{})
      page = Code
               |>Repo.paginate(params)
      render(conn, "index.html", codes: page.entries, default_image: @default_image, changeset: changeset, page: page)

    else
    changeset = Codes.change_code(%Code{})
    page = Codes.list_codes_by_user_id(conn)
                                  |>Repo.paginate(params)


    render(conn, "index.html", codes: page.entries, default_image: @default_image, changeset: changeset, page: page)

    end
    # IO.inspect(codes)
  end

  def new(conn, _params) do
    changeset = Codes.change_code(%Code{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"code" => code_params}) do
    code_params = Map.put(code_params, "user_id", conn.assigns.current_user.id)

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
    render(conn, "show.html", code: code, default_image: @default_image)
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

    if code.videos==[] && code.features==[] && code.leaderships==[] && code.headers==[] && code.images==[] && code.facilitys == [] do
    {:ok, _code} = Codes.delete_code(code)

    conn
    |> put_flash(:info, "Code deleted successfully.")
    |> redirect(to: Routes.code_path(conn, :index))

    else
      conn
      |>put_flash(:error, "cannot delete code ")
      |> redirect(to: Routes.code_path(conn, :index))
    end
  end
  def search(conn, %{"code" => %{"search" => search_params}}) do
    # codes = Codes.search(conn,search_params)
    changeset = Codes.change_code(%Code{})
    page = Codes.search(conn,search_params)
                |>Repo.paginate(conn.params)
  case page.entries do
  [] ->
  conn
  |> put_flash(:error, "no results")
  |> render( "index.html", codes: [], changeset: changeset, page: page)
  _ ->
  conn

  |> put_flash(:info, "code searched successfully.")

  |> render( "index.html", codes: page.entries, changeset: changeset, page: page)

  end

  end

end
