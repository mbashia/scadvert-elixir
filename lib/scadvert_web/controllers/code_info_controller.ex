defmodule ScadvertWeb.CodeInfoController do
  use ScadvertWeb, :controller
  # require Ecto
  import Ecto.Query, warn: false


  alias Scadvert.Codes
  alias Scadvert.Accounts
  # alias Scadvert.Repo
  plug :put_layout, "show_info.html"




  def show(conn, %{"name" => name,"user_id" => user_id}) do
    code = Codes.list_code_by_name(name)
    features= List.first(code.features)
    videos = List.first(code.videos)
    headers =List.first(code.headers)
    leaderships = List.first(code.leaderships)
    images = code.images
    facilitys= List.first(code.facilitys)
    user  = Accounts.get_user!(user_id)


    details = String.replace( user.more_details,"</p>","")
    new_details=String.replace(details, "<p>","|")
    details_pro = String.split(new_details, "|", trim: true)

IO.inspect(details_pro)

    render(conn, "show.html", features: features, code: code, videos: videos,headers: headers, leaderships: leaderships, facilitys: facilitys, images: images,user: user, details: details_pro, user_details: user.more_details )
  end
end
