defmodule ScadvertWeb.FacilityController do
  use ScadvertWeb, :controller

  use Ecto.Schema
  alias Scadvert.Repo
  alias Scadvert.Facilitys
  alias Scadvert.Facilitys.Facility
  alias Scadvert.Functions
  import Ecto.Query, warn: false



  @default_image :"/images/phoenix.png"

  plug :put_layout, "newlayout.html"

  def index(conn, params) do
    if conn.assigns.current_user.role == true do
      changeset = Facilitys.change_facility(%Facility{})

      # facilitys = Facilitys.list_all_facilitys()
      page = Facilitys.list_all_facilitys()
                |>Repo.paginate(params)
      render(conn, "index.html", facilitys: page.entries, default_image: @default_image, changeset: changeset, page: page)
    else
      changeset = Facilitys.change_facility(%Facility{})
      page = Facilitys.list_facilitys_by_user_id(conn)

                    |>Repo.paginate(params)

    render(conn, "index.html", facilitys: page.entries, default_image: @default_image, changeset: changeset, page: page)
    end

  end

  def new(conn, _params) do
    changeset = Facilitys.change_facility(%Facility{})
    codes = Functions.list_codes(conn)

    render(conn, "new.html", changeset: changeset, codes: codes)
  end

  def create(conn, %{"facility" => facility_params}) do
    facility_params = Map.put(facility_params, "user_id", conn.assigns.current_user.id)
    codes = Functions.list_codes(conn)
    case Facilitys.create_facility(facility_params) do
      {:ok, facility} ->
        conn
        |> put_flash(:info, "Facility created successfully.")
        |> redirect(to: Routes.facility_path(conn, :show, facility))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, codes: codes)
    end
  end

  def show(conn, %{"id" => id}) do
    facility = Facilitys.get_facility!(id)
    codes = Functions.list_codes(conn)
    render(conn, "show.html", facility: facility, codes: codes, default_image: @default_image)
  end

  def edit(conn, %{"id" => id}) do
    facility = Facilitys.get_facility!(id)
    changeset = Facilitys.change_facility(facility)
    codes = Functions.list_codes(conn)

    render(conn, "edit.html", facility: facility, changeset: changeset, codes: codes)
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
  def search(conn, %{"facility" => %{"search" => search_params}}) do
    changeset = Facilitys.change_facility(%Facility{})
    page = search_params(conn,search_params)
                     |>Repo.paginate(conn.params)
  case page.entries do
  [] ->
  conn
  |> put_flash(:error, "no results")
  |> render( "index.html", facilitys: [], changeset: changeset, page: page)
  _ ->
  conn

  |> put_flash(:info, "facility searched successfully.")

  |> render( "index.html", facilitys: page.entries, changeset: changeset, page: page)

  end

  end
  defp search_params(conn,params)do
    user_id = conn.assigns.current_user.id
     from(f in Facility, where: fragment("? LIKE ?", f.name, ^"%#{params}%")  and f.user_id == ^user_id)
    # facilitys = Repo.all(query)



  end
end
