defmodule ScadvertWeb.CodeInfoController do
  use ScadvertWeb, :controller
  require Ecto
  import Ecto.Query, warn: false


  alias Scadvert.Codes
  alias Scadvert.Repo
  plug :put_layout, "show_info.html"




  def show(conn, %{"id" => id}) do
    code = Codes.list_code_by_id(id)
    features= code.features
    videos = code.videos
    headers =code.headers
    leaderships = code.leaderships
    images = code.images
    facilitys= code.facilitys

    IO.inspect facilitys

    render(conn, "show.html", features: features, code: code, videos: videos,headers: headers, leaderships: leaderships, facilitys: facilitys, images: images)
  end
end
