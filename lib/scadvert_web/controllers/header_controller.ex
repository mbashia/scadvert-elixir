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
    if conn.assigns.current_user.role == "admin" do
      changeset = Headers.change_header(%Header{})

      page =
        Headers.list_all_headers()
        |> Repo.paginate(params)

      render(conn, "index.html",
        headers: page.entries,
        default_image: @default_image,
        page: page,
        changeset: changeset,
        total_pages: page.total_pages
      )
    else
      changeset = Headers.change_header(%Header{})

      page =
        Headers.list_headers_by_user_id(conn)
        |> Repo.paginate(params)

      render(conn, "index.html",
        changeset: changeset,
        headers: page.entries,
        default_image: @default_image,
        page: page,
        total_pages: page.total_pages
      )
    end
  end

  def new(conn, _params) do
    user_id = conn.assigns.current_user.id
    changeset = Headers.change_header(%Header{})
    codes = Functions.list_codes(user_id)

    render(conn, "new.html", changeset: changeset, codes: codes, default_image: @default_image)
  end

  def create(conn, %{"header" => header_params}) do
    user_id = conn.assigns.current_user.id

    header_params = Map.put(header_params, "user_id", user_id)
    codes = Functions.list_codes(user_id)

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
    user_id = header.user_id
    render(conn, "show.html", header: header, default_image: @default_image, user_id: user_id)
  end

  def edit(conn, %{"id" => id}) do
    header = Headers.get_header!(id)
    user_id = header.user_id
    changeset = Headers.change_header(header)
    codes = Functions.list_codes(user_id)

    render(conn, "edit.html", header: header, changeset: changeset, codes: codes, user_id: user_id)
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

    page =
      search_params(conn, search_params)
      |> Repo.paginate(conn.params)

    case page.entries do
      [] ->
        conn
        |> put_flash(:error, "no results")
        |> render("index.html",
          headers: [],
          changeset: changeset,
          page: page,
          total_pages: page.total_pages
        )

      _ ->
        if Enum.count(page.entries) == 1 do
          conn
          |> put_flash(:info, "Header searched successfully.")
          |> render("index.html",
            headers: page.entries,
            changeset: changeset,
            page: page,
            default_image: @default_image,
            total_pages: page.total_pages
          )
        else
          conn
          |> put_flash(:info, "Headers searched successfully.")
          |> render("index.html",
            headers: page.entries,
            changeset: changeset,
            page: page,
            default_image: @default_image,
            total_pages: page.total_pages
          )
        end
    end
  end

  defp search_params(conn, params) do
    params =
      cond do
        params == "active" ->
          "true"

        params == "inactive" ->
          "false"

        true ->
          params
      end

    user = conn.assigns.current_user

    if user.role == "admin" do
      from(h in Header,
        join: c in assoc(h, :codes),
        where:
          fragment("? LIKE ?", c.name, ^"%#{params}%") or
            fragment("? LIKE ?", h.name, ^"%#{params}%") or
            fragment("? LIKE ?", h.description, ^"%#{params}%") or
            fragment("? LIKE ?", h.status, ^"%#{params}%"),
        preload: [:codes]
      )
    else
      from(h in Header,
        join: c in assoc(h, :codes),
        where:
          fragment("? LIKE ?", c.name, ^"%#{params}%") or
            fragment("? LIKE ?", h.name, ^"%#{params}%") or
            fragment("? LIKE ?", h.description, ^"%#{params}%") or
            fragment("? LIKE ?", h.status, ^"%#{params}%"),
        where: h.user_id == ^user.id,
        preload: [:codes]
      )
    end
  end
end
