defmodule ScadvertWeb.CodeInfoController do
  use ScadvertWeb, :controller
  # require Ecto
  import Ecto.Query, warn: false

  alias Scadvert.Codes
  alias Scadvert.Accounts
  alias Scadvert.Feedbacks
  alias Scadvert.Feedbacks.Feedback
  # alias Scadvert.Repo
  plug :put_layout, "show_info.html"

  def show(conn, %{"name" => name}) do
    code = Codes.list_code_by_name(name)
    user_id = code.user_id
    features = List.first(code.features)
    videos = List.first(code.videos)
    headers = List.first(code.headers)
    leaderships = List.first(code.leaderships)
    images = code.images
    facilitys = List.first(code.facilitys)
    user = Accounts.get_user!(user_id)
    changeset = Feedbacks.change_feedback(%Feedback{})

    # details = String.replace( user.more_details,"</p>","")
    # new_details=String.replace(details, "<p>","|")
    # details_pro = String.split(new_details, "|", trim: true)

    render(conn, "show.html",
      features: features,
      code: code,
      videos: videos,
      headers: headers,
      leaderships: leaderships,
      facilitys: facilitys,
      images: images,
      user: user,
      user_details: user.more_details,
      changeset: changeset
    )
  end

  def create(conn, %{"feedback" => feedback_params}) do
    code_id = feedback_params["code_id"]
    code = Codes.get_code!(code_id)

    case Feedbacks.create_feedback(feedback_params) do
      {:ok, _feedback} ->
        conn
        |> put_flash(:info, "Feedback created successfully.")
        |> redirect(to: Routes.code_info_path(conn, :show, code.name))

      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> redirect(to: Routes.code_info_path(conn, :show, code.name))
    end
  end
end
