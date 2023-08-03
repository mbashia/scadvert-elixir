defmodule ScadvertWeb.FeedbackController do
  use ScadvertWeb, :controller

  alias Scadvert.Feedbacks
  import Ecto.Query, warn: false
  alias Scadvert.Repo

  alias Scadvert.Feedbacks.Feedback
  plug :put_layout, "newlayout.html"

  def index(conn, params) do
    changeset = Feedbacks.change_feedback(%Feedback{})
    page = Feedbacks.list_feedbacks()
    |>Repo.paginate(params)



    render(conn, "index.html", feedbacks: page.entries, changeset: changeset, page: page, total_pages: page.total_pages)
  end

  def new(conn, _params) do
    changeset = Feedbacks.change_feedback(%Feedback{})
    render(conn, "new.html", changeset: changeset)
  end

  # def create(conn, %{"feedback" => feedback_params}) do
  #   case Feedbacks.create_feedback(feedback_params) do
  #     {:ok, feedback} ->
  #       conn
  #       |> put_flash(:info, "Feedback created successfully.")
  #       |> redirect(to: Routes.feedback_path(conn, :show, feedback))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # end

  def show(conn, %{"id" => id}) do
    feedback = Feedbacks.get_feedback!(id)
    render(conn, "show.html", feedback: feedback)
  end

  def edit(conn, %{"id" => id}) do
    feedback = Feedbacks.get_feedback!(id)
    changeset = Feedbacks.change_feedback(feedback)
    render(conn, "edit.html", feedback: feedback, changeset: changeset)
  end

  def update(conn, %{"id" => id, "feedback" => feedback_params}) do
    feedback = Feedbacks.get_feedback!(id)

    case Feedbacks.update_feedback(feedback, feedback_params) do
      {:ok, feedback} ->
        conn
        |> put_flash(:info, "Feedback updated successfully.")
        |> redirect(to: Routes.feedback_path(conn, :show, feedback))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", feedback: feedback, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    feedback = Feedbacks.get_feedback!(id)
    {:ok, _feedback} = Feedbacks.delete_feedback(feedback)

    conn
    |> put_flash(:info, "Feedback deleted successfully.")
    |> redirect(to: Routes.feedback_path(conn, :index))
  end
  def search( conn,%{"feedback" => %{"search" => search_params}}) do
    changeset = Feedbacks.change_feedback(%Feedback{})
      feedbacks = search_params(conn,search_params)
      case feedbacks do
        [] ->
          conn
          |> put_flash(:error, "no results")
          |>render("index.html", feedbacks: [], changeset: changeset)

        _ ->
          conn
          |> put_flash(:info, "feedback searched successfully.")
          |>render("index.html", feedbacks: feedbacks, changeset: changeset)


      end


  end
  defp search_params(conn,params) do
      query = from(f in Feedback,
      join: c in assoc(f, :code),where: fragment("? LIKE ?", c.name, ^"%#{params}%"), preload: [:code]
      )
      feedbacks = Repo.all(query)
      feedbacks
  end
end
