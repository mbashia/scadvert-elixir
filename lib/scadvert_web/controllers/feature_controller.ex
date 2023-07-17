defmodule ScadvertWeb.FeatureController do
  use ScadvertWeb, :controller
  alias Scadvert.Repo
  import Ecto.Query, warn: false

  alias Scadvert.Features
  alias Scadvert.Features.Feature
  alias Scadvert.Functions
  @default_image  :"/images/phoenix.png"


  plug :put_layout, "newlayout.html"

  def index(conn, params) do
    if conn.assigns.current_user.role == true do
      changeset = Features.change_feature(%Feature{})

    page = Features.list_all_features()
                |>Repo.paginate(params)
    render(conn, "index.html", features: page.entries, default_image: @default_image,changeset: changeset ,page: page)
    else
      changeset = Features.change_feature(%Feature{})


    page = Features.list_features_by_user_id(conn)
                            |>Repo.paginate(params)
    render(conn, "index.html", features: page.entries, default_image: @default_image,changeset: changeset ,page: page )
    end
  end

  def new(conn, _params) do
    changeset = Features.change_feature(%Feature{})
    codes = Functions.list_codes(conn)

    render(conn, "new.html", changeset: changeset, codes: codes)
  end

  def create(conn, %{"feature" => feature_params}) do
    feature_params = Map.put(feature_params, "user_id", conn.assigns.current_user.id)
    codes = Functions.list_codes(conn)

    case Features.create_feature(feature_params) do
      {:ok, feature} ->
        conn
        |> put_flash(:info, "Feature created successfully.")
        |> redirect(to: Routes.feature_path(conn, :show, feature))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset,codes: codes)
    end
  end

  def show(conn, %{"id" => id}) do
    feature = Features.get_feature!(id)
    render(conn, "show.html", feature: feature, default_image: @default_image)
  end

  def edit(conn, %{"id" => id}) do
    feature = Features.get_feature!(id)
    codes = Functions.list_codes(conn)

    changeset = Features.change_feature(feature)
    render(conn, "edit.html", feature: feature, changeset: changeset, codes: codes)
  end

  def update(conn, %{"id" => id, "feature" => feature_params}) do
    feature = Features.get_feature!(id)

    case Features.update_feature(feature, feature_params) do
      {:ok, feature} ->
        conn
        |> put_flash(:info, "Feature updated successfully.")
        |> redirect(to: Routes.feature_path(conn, :show, feature))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", feature: feature, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    feature = Features.get_feature!(id)
    {:ok, _feature} = Features.delete_feature(feature)

    conn
    |> put_flash(:info, "Feature deleted successfully.")
    |> redirect(to: Routes.feature_path(conn, :index))
  end
  def search(conn, %{"feature" => %{"search" => search_params}}) do
    changeset = Features.change_feature(%Feature{})
    page = search_params(conn,search_params)
                     |>Repo.paginate(conn.params)
  case page.entries do
  [] ->
  conn
  |> put_flash(:error, "no results")
  |> render( "index.html", features: [], changeset: changeset, page: page)
  _ ->
  conn

  |> put_flash(:info, "facility searched successfully.")

  |> render( "index.html", features: page.entries, changeset: changeset, page: page)

  end

  end
  defp search_params(conn,params)do
    user_id = conn.assigns.current_user.id
    from(f in Feature, where: fragment("? LIKE ?", f.name, ^"%#{params}%")  and f.user_id == ^user_id)



  end
end
