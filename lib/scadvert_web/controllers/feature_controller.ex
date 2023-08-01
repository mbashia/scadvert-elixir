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
    if conn.assigns.current_user.role == "admin" do
      changeset = Features.change_feature(%Feature{})

    page = Features.list_all_features()
                |>Repo.paginate(params)
    render(conn, "index.html", features: page.entries, default_image: @default_image,changeset: changeset ,page: page , total_pages: page.total_pages)
    else
      changeset = Features.change_feature(%Feature{})


    page = Features.list_features_by_user_id(conn)
                            |>Repo.paginate(params)
    render(conn, "index.html", features: page.entries, default_image: @default_image,changeset: changeset ,page: page , total_pages: page.total_pages )
    end
  end

  def new(conn, _params) do
    user_id = conn.assigns.current_user.id
    changeset = Features.change_feature(%Feature{})
    codes = Functions.list_codes(user_id)

    render(conn, "new.html", changeset: changeset, codes: codes)
  end

  def create(conn, %{"feature" => feature_params}) do
    user_id = conn.assigns.current_user.id

    feature_params = Map.put(feature_params, "user_id", user_id)
    codes = Functions.list_codes(user_id)

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
    user_id = feature.user_id
    render(conn, "show.html", feature: feature, default_image: @default_image, user_id: user_id)
  end

  def edit(conn, %{"id" => id}) do
    feature = Features.get_feature!(id)
    user_id = feature.user_id
    codes = Functions.list_codes(user_id)

    changeset = Features.change_feature(feature)
    render(conn, "edit.html", feature: feature, changeset: changeset, codes: codes, user_id: user_id)
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
  |> render( "index.html", features: [], changeset: changeset, page: page , total_pages: page.total_pages)
  _ ->
    if Enum.count(page.entries) ==1 do
  conn

  |> put_flash(:info, "feature searched successfully.")

  |> render( "index.html", features: page.entries, changeset: changeset, page: page, default_image: @default_image , total_pages: page.total_pages)
    else
      conn
      |> put_flash(:info, "features searched successfully.")

      |> render( "index.html", features: page.entries, changeset: changeset, page: page, default_image: @default_image , total_pages: page.total_pages)
    end


  end

  end
  defp search_params(conn,params)do
    user = conn.assigns.current_user
    params = cond do
      params=="active" ->
      "true"
      params =="inactive" ->
        "false"
      true ->
        params

      end
    if user.role == "admin" do
      from(f in Feature,
    join: c in assoc(f, :codes),
    where: fragment("? LIKE ?", c.name, ^"%#{params}%")  or fragment("? LIKE ?", f.name, ^"%#{params}%") or fragment("? LIKE ?", f.description, ^"%#{params}%") or fragment("? LIKE ?", f.status, ^"%#{params}%"),
    preload: [:codes])
    else
    from(f in Feature,
    join: c in assoc(f, :codes),
    where: fragment("? LIKE ?", c.name, ^"%#{params}%") or fragment("? LIKE ?", f.name, ^"%#{params}%") or fragment("? LIKE ?", f.description, ^"%#{params}%") or fragment("? LIKE ?", f.status, ^"%#{params}%"),  where: f.user_id == ^user.id,
    preload: [:codes])
    end


  end
end
