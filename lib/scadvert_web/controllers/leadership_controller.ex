defmodule ScadvertWeb.LeadershipController do
  use ScadvertWeb, :controller
  alias Scadvert.Repo
  import Ecto.Query, warn: false
  alias Scadvert.Leaderships
  alias Scadvert.Leaderships.Leadership
  alias Scadvert.Functions
  plug :put_layout, "newlayout.html"

  @default_image :"/images/phoenix.png"
  def index(conn, params) do
    if conn.assigns.current_user.role == "admin" do
      changeset = Leaderships.change_leadership(%Leadership{})

      page = Leaderships.list_all_leaderships()
                  |>Repo.paginate(params)
      render(conn, "index.html", leaderships: page.entries, default_image: @default_image, page: page, changeset: changeset)
    else
      changeset = Leaderships.change_leadership(%Leadership{})


    page = Leaderships.list_leaderships_by_user_id(conn)
                     |>Repo.paginate(params)
    render(conn, "index.html", leaderships: page.entries, default_image: @default_image, page: page, changeset: changeset)
    end

  end

  def new(conn, _params) do
    changeset = Leaderships.change_leadership(%Leadership{})

    codes = Functions.list_codes(conn)

    render(conn, "new.html", changeset: changeset, codes: codes)
  end

  def create(conn, %{"leadership" => leadership_params}) do
    leadership_params = Map.put(leadership_params, "user_id", conn.assigns.current_user.id)
    codes = Functions.list_codes(conn)

    case Leaderships.create_leadership(leadership_params) do
      {:ok, leadership} ->
        conn
        |> put_flash(:info, "Leadership created successfully.")
        |> redirect(to: Routes.leadership_path(conn, :show, leadership))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, codes: codes)
    end
  end

  def show(conn, %{"id" => id}) do
    leadership = Leaderships.get_leadership!(id)
    render(conn, "show.html", leadership: leadership, default_image: @default_image)
  end

  def edit(conn, %{"id" => id}) do

    leadership = Leaderships.get_leadership!(id)
    codes = Functions.list_codes(conn)
    changeset = Leaderships.change_leadership(leadership)
    render(conn, "edit.html", leadership: leadership, changeset: changeset, codes: codes)
  end

  def update(conn, %{"id" => id, "leadership" => leadership_params}) do
    leadership = Leaderships.get_leadership!(id)

    case Leaderships.update_leadership(leadership, leadership_params) do
      {:ok, leadership} ->
        conn
        |> put_flash(:info, "Leadership updated successfully.")
        |> redirect(to: Routes.leadership_path(conn, :show, leadership))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", leadership: leadership, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    leadership = Leaderships.get_leadership!(id)
    {:ok, _leadership} = Leaderships.delete_leadership(leadership)

    conn
    |> put_flash(:info, "Leadership deleted successfully.")
    |> redirect(to: Routes.leadership_path(conn, :index))
  end
  def search(conn, %{"leadership" => %{"search" => search_params}}) do
    changeset = Leaderships.change_leadership(%Leadership{})
    page = search_params(conn,search_params)
                     |>Repo.paginate(conn.params)
  case page.entries do
  [] ->
  conn
  |> put_flash(:error, "no results")
  |> render( "index.html", leaderships: [], changeset: changeset, page: page)
  _ ->
  conn

  |> put_flash(:info, "history searched successfully.")

  |> render( "index.html", leaderships: page.entries, changeset: changeset, page: page, default_image: @default_image)

  end

  end
  defp search_params(conn,params)do
    user_id = conn.assigns.current_user.id
    from(l in Leadership,
    join: c in assoc(l, :codes),
     where: fragment("? LIKE ?", c.name, ^"%#{params}%")  and l.user_id == ^user_id,
     preload: [:codes])



  end

end
