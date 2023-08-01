defmodule ScadvertWeb.ClientController do
  use ScadvertWeb, :controller
  alias Scadvert.Functions
  alias Scadvert.Accounts
  alias Scadvert.Repo
   alias Scadvert.Accounts.User
  alias Scadvert.Users
  import Ecto.Query, warn: false



  plug :put_layout, "newlayout.html"



  # def action(conn, _) do
  #   apply(__MODULE__, action_name(conn),
  #   [conn, conn.params, conn.assigns.current_user])
  # end



def index(conn,params)do
  page = Accounts.list_users()
                    |>Repo.paginate(params)
   changeset = Users.change_user(%User{})

    render(conn, "client.html", users: page.entries, page: page, changeset: changeset, total_pages: page.total_pages)

end
@spec show(any, map) :: nil
def show(conn, %{"id" => id}) do
user = Accounts.get_user!(id)


render(conn, "show.html", user: user)
end

def edit(conn, %{"id" => id}) do

  user = Accounts.get_user!(id)
  changeset = Users.change_user(user)
  IO.inspect(changeset)
  render(conn, "edit.html", user: user, changeset: changeset)
end
def update(conn, %{"id" => id, "user" => user_params}) do
  user = Accounts.get_user!(id)
  case Accounts.update_user(user, user_params) do
    {:ok, user} ->
      if conn.assigns.current_user.role == "admin" do
        conn
        |> put_flash(:info, "User updated successfully")
        |> redirect(to: Routes.client_path(conn, :index))

      else
      conn
      |> put_flash(:info, "User updated successfully")
      |> redirect(to: Routes.client_path(conn, :profile,user))
      end
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset )
  end


end

def profile(conn,%{"id" => id}) do

  user = Accounts.get_user!(id)

  changeset = Users.change_user(user)

  render(conn, "profile.html", user: user, changeset: changeset)
end

# def update_profile(conn,%{"id"=>id})do
#   user = Functions.get_user_by_id(conn)

#   # changeset = Users.change_user(%User{},user)

#   render(conn, "update_profile.html")

# end

  def delete(conn,  %{"id" => id}) do
    user = Accounts.get_user!(id)
    cond do
      user.status == true ->

        case Accounts.update_user(user, %{status: false})do
      {:ok,_user} ->
        conn
        |> put_flash(:info, "User deactivated successfully")
        |> redirect(to: Routes.client_path(conn, :index))
        {:error,_changeset} ->
        conn
        |> put_flash(:error, "Failed to deactivate user")
        |> redirect(to: Routes.client_path(conn, :index))


      end
      user.status == false ->

        case Accounts.update_user(user, %{status: true})do
      {:ok,_user} ->
        conn
        |> put_flash(:info, "User activated successfully")
        |> redirect(to: Routes.client_path(conn, :index))
        {:error, _changeset} ->
        conn
        |> put_flash(:error, "Failed to activate user:")
        |> redirect(to: Routes.client_path(conn, :index))

    end
    true ->
      conn
      |> put_flash(:error, "Invalid user status")
      |> redirect(to: Routes.client_path(conn, :index))
  end


  end
  def search(conn, %{"user" => %{"search" => search_params}}) do
    changeset = Users.change_user(%User{})
    page = search_params(search_params)
                     |>Repo.paginate(conn.params)
  case page.entries do
  [] ->
  conn
  |> put_flash(:error, "no results")
  |> render( "client.html", users: [], changeset: changeset, page: page, total_pages: page.total_pages)
  _ ->
    if Enum.count(page.entries) ==1 do
      IO.inspect(page.entries)
    conn

    |> put_flash(:info, "user searched successfully.")
    |> render( "client.html", users: page.entries, changeset: changeset, page: page,  total_pages: page.total_pages)

    else
      conn
      |> put_flash(:info, "users searched successfully.")
      |> render( "client.html", users: page.entries, changeset: changeset, page: page,  total_pages: page.total_pages)

    end


  end

  end
  defp search_params(params)do

    params = cond do
      params=="active" ->
      "true"
      params =="inactive" ->
        "false"
      true ->
        params

      end
   query = from(u in User,

     where: fragment("? LIKE ?", u.firstname, ^"%#{params}%") or fragment("? LIKE ?", u.lastname, ^"%#{params}%") or fragment("? LIKE ?", u.email, ^"%#{params}%")  or fragment("? LIKE ?", u.phone_number, ^"%#{params}%") or fragment("? LIKE ?", u.gender, ^"%#{params}%")or fragment("? LIKE ?", u.role, ^"%#{params}%")or fragment("? LIKE ?", u.status, ^"%#{params}%")   )

    query

  end


end


# user.status == true ->
#   changeset = user
#   |> Ecto.Changeset.change()
#   |> Ecto.Changeset.put_change(:status, false)
#   IO.inspect(changeset.changes)
#   case Accounts.update_user(user, changeset.changes)do
# {:ok,_user} ->
#   conn
#   |> put_flash(:info, "User deactivated successfully")
#   |> redirect(to: Routes.client_path(conn, :index))
#   {:error,_changeset} ->
#   conn
#   |> put_flash(:error, "Failed to deactivate user")
#   |> redirect(to: Routes.client_path(conn, :index))


# end
# user.status == false ->
#   changeset = user
#   |> Ecto.Changeset.change()
#   |> Ecto.Changeset.put_change(:status, true)
#   IO.inspect(changeset.changes)
#   case Accounts.update_user(user, %{status: true})do
# {:ok,_user} ->
#   conn
#   |> put_flash(:info, "User activated successfully")
#   |> redirect(to: Routes.client_path(conn, :index))
#   {:error, _changeset} ->
#   conn
#   |> put_flash(:error, "Failed to activate user:")
#   |> redirect(to: Routes.client_path(conn, :index))

# end
