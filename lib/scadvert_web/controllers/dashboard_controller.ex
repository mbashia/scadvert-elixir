defmodule ScadvertWeb.DashboardController do
    use ScadvertWeb, :controller
    alias Scadvert.Functions

    plug :put_layout, "newlayout.html"


  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
    [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do

    facilitys = Functions.facilitys_count(current_user)
    IO.inspect(facilitys)

    render(conn, "dashboard.html", facilitys: facilitys)


  end
end
