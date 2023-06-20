defmodule ScadvertWeb.FacilityController do
  use ScadvertWeb, :controller
  # use Ecto.Repo
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  # alias Scadvert.Repo
  alias Scadvert.Facilitys
  alias Scadvert.Facilitys.Facility
  alias Scadvert.Functions



  def index(conn, _params) do
    facilitys = Facilitys.list_facilitys_by_user_id(conn)

    render(conn, "index.html", facilitys: facilitys)
  end

  def new(conn, _params) do
    changeset = Facilitys.change_facility(%Facility{})
    codes = Functions.list_codes(conn)

    render(conn, "new.html", changeset: changeset, codes: codes)
  end

  def create(conn, %{"facility" => facility_params}) do
    facility_params = Map.put(facility_params, "user_id", conn.assigns.current_user.id)

    case Facilitys.create_facility(facility_params) do
      {:ok, facility} ->
        conn
        |> put_flash(:info, "Facility created successfully.")
        |> redirect(to: Routes.facility_path(conn, :show, facility))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    facility = Facilitys.get_facility!(id)

    render(conn, "show.html", facility: facility)
  end

  def edit(conn, %{"id" => id}) do
    facility = Facilitys.get_facility!(id)
    changeset = Facilitys.change_facility(facility)
    render(conn, "edit.html", facility: facility, changeset: changeset)
  end

  def update(conn, %{"id" => id, "facility" => facility_params}) do
    facility = Facilitys.get_facility!(id)

    case Facilitys.update_facility(facility, facility_params) do
      {:ok, facility} ->
        conn
        |> put_flash(:info, "Facility updated successfully.")
        |> redirect(to: Routes.facility_path(conn, :show, facility))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", facility: facility, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    facility = Facilitys.get_facility!(id)
    {:ok, _facility} = Facilitys.delete_facility(facility)

    conn
    |> put_flash(:info, "Facility deleted successfully.")
    |> redirect(to: Routes.facility_path(conn, :index))
  end
end
