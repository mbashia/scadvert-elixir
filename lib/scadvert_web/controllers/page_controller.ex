defmodule ScadvertWeb.PageController do
  use ScadvertWeb, :controller

  plug :put_layout, "login_registration.html"


  def index(conn, _params) do
    render(conn, "index.html")
  end
  def confirm(conn,_params)do
    render(conn, "email.html")
   end
end
