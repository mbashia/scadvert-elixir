defmodule ScadvertWeb.PageController do
  use ScadvertWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
