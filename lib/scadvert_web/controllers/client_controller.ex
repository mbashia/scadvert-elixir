defmodule ScadvertWeb.ClientController do
  use ScadvertWeb, :controller
  alias Scadvert.Functions

  plug :put_layout, "newlayout.html"



  # def action(conn, _) do
  #   apply(__MODULE__, action_name(conn),
  #   [conn, conn.params, conn.assigns.current_user])
  # end



def index(conn,_params)do
     users = Functions.users_count(conn.params)

  render(conn, "client.html", users: users)

end

end
