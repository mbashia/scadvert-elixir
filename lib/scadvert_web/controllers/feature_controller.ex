defmodule ScadvertWeb.FeatureController do
  use ScadvertWeb, :controller

  alias Scadvert.Features
  alias Scadvert.Features.Feature

  def index(conn, _params) do
    features = Features.list_features()
    render(conn, "index.html", features: features)
  end

  def new(conn, _params) do
    changeset = Features.change_feature(%Feature{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"feature" => feature_params}) do
    feature_params = Map.put(feature_params, "user_id", conn.assigns.current_user.id)

    case Features.create_feature(feature_params) do
      {:ok, feature} ->
        conn
        |> put_flash(:info, "Feature created successfully.")
        |> redirect(to: Routes.feature_path(conn, :show, feature))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    feature = Features.get_feature!(id)
    render(conn, "show.html", feature: feature)
  end

  def edit(conn, %{"id" => id}) do
    feature = Features.get_feature!(id)
    changeset = Features.change_feature(feature)
    render(conn, "edit.html", feature: feature, changeset: changeset)
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
end
