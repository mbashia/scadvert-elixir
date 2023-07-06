defmodule ScadvertWeb.ClientController do
  use ScadvertWeb, :controller
  alias Scadvert.Functions
  alias Scadvert.Accounts
  alias Scadvert.Accounts.User
  alias Scadvert.Users


  plug :put_layout, "newlayout.html"



  # def action(conn, _) do
  #   apply(__MODULE__, action_name(conn),
  #   [conn, conn.params, conn.assigns.current_user])
  # end



def index(conn,_params)do
  users = Accounts.list_users()

  render(conn, "client.html", users: users)

end
@spec show(any, map) :: nil
def show(conn, %{"id" => id}) do
user = Accounts.get_user!(id)
render(conn, "show.html", user: user)
end

def edit(conn, %{"id" => id}) do

  user = Accounts.get_user!(id)
  changeset = Users.change_user(user)
  render(conn, "edit.html", user: user, changeset: changeset)
end
def update(conn, %{"id" => id, "user" => user_params}) do
  user = Accounts.get_user!(id)

  case Accounts.update_user(user, user_params) do
    {:ok, user} ->
      conn
      |> put_flash(:info, "User updated successfully")
      |> redirect(to: Routes.client_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
  end


end

def profile(conn,_params) do

  user = Functions.get_user_by_id(conn)
  IO.inspect(user.id)
  render(conn, "profile.html", user: user)
end

def update_profile(conn,%{"id"=>id})do
  user = Functions.get_user_by_id(conn)

  # changeset = Users.change_user(%User{},user)

  render(conn, "update_profile.html")

end

# def deactivate(conn, %{"id" => id}) do
#   user = Accounts.get_user!(id)
#   {:ok, _feature} = Features.delete_feature(feature)

#   conn
#   |> put_flash(:info, "Feature deleted successfully.")
#   |> redirect(to: Routes.feature_path(conn, :index))
# end





# def delete(conn, %{"id" => id}) do
#   user = Accounts.get_user!(id)


# end

# deactivate user instead of deleting

end
