defmodule ScadvertWeb.ClientController do
  use ScadvertWeb, :controller
  alias Scadvert.Functions

  plug :put_layout, "newlayout.html"



  # def action(conn, _) do
  #   apply(__MODULE__, action_name(conn),
  #   [conn, conn.params, conn.assigns.current_user])
  # end



def index(conn,_params)do

  render(conn, "client.html")

end

end
