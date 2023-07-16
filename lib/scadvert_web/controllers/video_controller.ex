defmodule ScadvertWeb.VideoController do
  use ScadvertWeb, :controller
  alias Scadvert.Repo
  import Ecto.Query, warn: false
  alias Scadvert.Videos
  alias Scadvert.Videos.Video
  alias Scadvert.Functions

  plug :put_layout, "newlayout.html"
  @default_image :"/images/phoenix.png"

  def index(conn, params) do
    if conn.assigns.current_user.email in ["vic@gmail.com","john@gmail.com"] do
      changeset = Videos.change_video(%Video{})

      page = Videos
                  |>Repo.paginate(params)
      render(conn, "index.html", videos: page.entries, default_image: @default_image, page: page, changeset: changeset)
    else
      changeset = Videos.change_video(%Video{})

    page = Videos.list_videos_by_user_id(conn)
                      |>Repo.paginate(params)

    render(conn, "index.html", videos: page.entries, default_image: @default_image, page: page, changeset: changeset)
    end
  end

  def new(conn, _params) do
    changeset = Videos.change_video(%Video{})
    codes = Functions.list_codes(conn)

    render(conn, "new.html", changeset: changeset, codes: codes)
  end

  def create(conn, %{"video" => video_params}) do
    video_params = Map.put(video_params, "user_id", conn.assigns.current_user.id)
    codes = Functions.list_codes(conn)

    case Videos.create_video(video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: Routes.video_path(conn, :show, video))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, codes: codes)
    end
  end

  def show(conn, %{"id" => id}) do
    video = Videos.get_video!(id)
    render(conn, "show.html", video: video, default_image: @default_image)
  end

  def edit(conn, %{"id" => id}) do
    video = Videos.get_video!(id)
    codes = Functions.list_codes(conn)

    changeset = Videos.change_video(video)
    render(conn, "edit.html", video: video, changeset: changeset, codes: codes)
  end

  def update(conn, %{"id" => id, "video" => video_params}) do
    video = Videos.get_video!(id)

    case Videos.update_video(video, video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: Routes.video_path(conn, :show, video))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    video = Videos.get_video!(id)
    {:ok, _video} = Videos.delete_video(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: Routes.video_path(conn, :index))
  end

  def search(conn, %{"video" => %{"search" => search_params}}) do
    changeset = Videos.change_video(%Video{})
    page = search_params(conn,search_params)
                     |>Repo.paginate(conn.params)
  case page.entries do
  [] ->
  conn
  |> put_flash(:error, "no results")
  |> render( "index.html", videos: [], changeset: changeset, page: page)
  _ ->
  conn

  |> put_flash(:info, "video searched successfully.")

  |> render( "index.html", videos: page.entries, changeset: changeset, page: page)

  end

  end
  defp search_params(conn,params)do
    user_id = conn.assigns.current_user.id
    query = from(f in Video, where: fragment("? LIKE ?", f.name, ^"%#{params}%")  and f.user_id == ^user_id)



end


end
