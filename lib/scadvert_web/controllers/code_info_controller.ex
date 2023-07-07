defmodule ScadvertWeb.CodeInfoController do
  use ScadvertWeb, :controller
  require Ecto
  import Ecto.Query, warn: false


  alias Scadvert.Codes
  alias Scadvert.Repo
  plug :put_layout, "newlayout.html"




  def show(conn, %{"id" => id}) do
    code = Codes.list_codes_by_id(id)
    |>Repo.preload(:features)
    |>Repo.preload(:facilitys)
    |>Repo.preload(:images)
    |>Repo.preload(:videos)
    |>Repo.preload(:leaderships)
    |>Repo.preload(:headers)

    features = Enum.map(code, fn code ->
      code.features
    end)

    IO.inspect(feature)







    render(conn, "show.html", features: features)
  end
end
