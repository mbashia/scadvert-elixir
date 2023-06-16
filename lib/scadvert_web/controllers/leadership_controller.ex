defmodule ScadvertWeb.LeadershipController do
  use ScadvertWeb, :controller

  alias Scadvert.Leaderships
  alias Scadvert.Leaderships.Leadership

  def index(conn, _params) do
    leaderships = Leaderships.list_leaderships()
    render(conn, "index.html", leaderships: leaderships)
  end

  def new(conn, _params) do
    changeset = Leaderships.change_leadership(%Leadership{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"leadership" => leadership_params}) do
    case Leaderships.create_leadership(leadership_params) do
      {:ok, leadership} ->
        conn
        |> put_flash(:info, "Leadership created successfully.")
        |> redirect(to: Routes.leadership_path(conn, :show, leadership))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    leadership = Leaderships.get_leadership!(id)
    render(conn, "show.html", leadership: leadership)
  end

  def edit(conn, %{"id" => id}) do
    leadership = Leaderships.get_leadership!(id)
    changeset = Leaderships.change_leadership(leadership)
    render(conn, "edit.html", leadership: leadership, changeset: changeset)
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
end
