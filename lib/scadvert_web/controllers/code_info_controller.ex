defmodule ScadvertWeb.CodeInfoController do
  use ScadvertWeb, :controller
  require Ecto
  import Ecto.Query, warn: false


  alias Scadvert.Codes
  alias Scadvert.Repo
  plug :put_layout, "newlayout.html"




  def show(conn, %{"id" => id}) do
    code = Codes.list_code_by_id(id)
    IO.inspect(code)
    
    # features = Enum.map(code, fn code ->
    #   code.features
    # end)
    features= code.features
    IO.inspect(code)
    IO.write("this are codes")

    render(conn, "show.html", features: features, code: code)
  end
end
