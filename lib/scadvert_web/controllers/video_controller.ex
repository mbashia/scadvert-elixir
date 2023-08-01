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
    if conn.assigns.current_user.role == "admin" do
      changeset = Videos.change_video(%Video{})

      page = Videos.list_all_videos()
                  |>Repo.paginate(params)
      render(conn, "index.html", videos: page.entries, default_image: @default_image, page: page, changeset: changeset, total_pages: page.total_pages)
    else
      changeset = Videos.change_video(%Video{})

    page = Videos.list_videos_by_user_id(conn)
                      |>Repo.paginate(params)

    render(conn, "index.html", videos: page.entries, default_image: @default_image, page: page, changeset: changeset, total_pages: page.total_pages)
    end
  end

  def new(conn, _params) do
    changeset = Videos.change_video(%Video{})
    user_id = conn.assigns.current_user.id
    codes = Functions.list_codes(user_id)

    render(conn, "new.html", changeset: changeset, codes: codes)
  end

  def create(conn, %{"video" => video_params}) do
    user_id = conn.assigns.current_user.id

    video_params = Map.put(video_params, "user_id", user_id)
    codes = Functions.list_codes(user_id)

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
    user_id = video.user_id
    render(conn, "show.html", video: video, default_image: @default_image, user_id: user_id)
  end

  def edit(conn, %{"id" => id}) do
    video = Videos.get_video!(id)
    user_id =  video.user_id
    codes = Functions.list_codes(user_id)

    changeset = Videos.change_video(video)
    render(conn, "edit.html", video: video, changeset: changeset, codes: codes, user_id: user_id)
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
    IO.inspect(search_params)
    changeset = Videos.change_video(%Video{})
    page = search_params(conn,search_params)
                     |>Repo.paginate(conn.params)
  case page.entries do
  [] ->
  conn
  |> put_flash(:error, "no results")
  |> render( "index.html", videos: [], changeset: changeset, page: page, total_pages: page.total_pages)
  _ ->
    if Enum.count(page.entries) == 1 do
  conn

  |> put_flash(:info, "video searched successfully.")

  |> render( "index.html", videos: page.entries, changeset: changeset, page: page, default_image: @default_image, total_pages: page.total_pages)
    else
      conn
      |> put_flash(:info, "videos searched successfully.")

      |> render( "index.html", videos: page.entries, changeset: changeset, page: page, default_image: @default_image, total_pages: page.total_pages)

    end
  end

  end
  defp search_params(conn,params)do
    params = cond do
      params=="active" ->
      "true"
      params =="inactive" ->
        "false"
      true ->
        params

      end
    user = conn.assigns.current_user
    if user.role =="admin"  do


    from(v in Video,
    join: c in assoc(v, :codes),
    where: fragment("? LIKE ?", c.name, ^"%#{params}%")  or fragment("? LIKE ?", v.name, ^"%#{params}%") or fragment("? LIKE ?", v.description, ^"%#{params}%") or fragment("? LIKE ?", v.status, ^"%#{params}%"),
    preload: [:codes])
    else
      from(v in Video,
    join: c in assoc(v, :codes),
    where: fragment("? LIKE ?", c.name, ^"%#{params}%")  or fragment("? LIKE ?", v.name, ^"%#{params}%") or fragment("? LIKE ?", v.description, ^"%#{params}%") or fragment("? LIKE ?", v.status, ^"%#{params}%"),where: v.user_id ==^user.id,
    preload: [:codes])
    end


end


end
