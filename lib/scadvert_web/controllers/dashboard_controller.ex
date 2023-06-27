defmodule ScadvertWeb.DashboardController do
  use ScadvertWeb, :controller
  alias ScadvertWeb.Functions

  plug :put_layout, "newlayout.html"


  apply(__MODULE__, action_name(conn),
  [conn, conn.params, conn.assigns.current_user])
end

def index(conn, _params, current_user) do

  facilitys = Functions.get_facilities(current_user)
  render(conn, "dashboard.html", facilitys: facilitys)

end
