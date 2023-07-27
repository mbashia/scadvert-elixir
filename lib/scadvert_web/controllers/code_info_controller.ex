defmodule ScadvertWeb.CodeInfoController do
  use ScadvertWeb, :controller
  # require Ecto
  import Ecto.Query, warn: false


  alias Scadvert.Codes
  # alias Scadvert.Repo
  plug :put_layout, "show_info.html"




  def show(conn, %{"id" => id}) do
    code = Codes.list_code_by_name(id)
    features= List.first(code.features)
    videos = List.first(code.videos)
    headers =List.first(code.headers)
    leaderships = List.first(code.leaderships)
    images = code.images
    facilitys= List.first(code.facilitys)

    IO.inspect(length(images))

    render(conn, "show.html", features: features, code: code, videos: videos,headers: headers, leaderships: leaderships, facilitys: facilitys, images: images)
  end
end
