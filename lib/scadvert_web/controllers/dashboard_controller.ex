defmodule ScadvertWeb.DashboardController do
    use ScadvertWeb, :controller
    alias Scadvert.Functions
    alias Scadvert.Repo
    alias Scadvert.Codes
    alias Scadvert.Facilitys
    alias Scadvert.Headers
    alias Scadvert.Features
    alias Scadvert.Images
    alias Scadvert.Leaderships
    alias Scadvert.Videos


    plug :put_layout, "newlayout.html"


  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
    [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do


    if current_user.email in ["vic@gmail.com","john@gmail.com"] do
    users = Functions.users_count()
    facilitys = Facilitys.list_facilitys()
    codes = Codes.list_codes()
    features = Features.list_features()
    headers = Headers.list_headers()
    videos = Videos.list_videos()
    leaderships = Leaderships.list_leaderships()
    images = Images.list_images()
    IO.inspect(codes)
    render(conn, "dashboard.html", facilitys: facilitys, codes: codes,features: features, headers: headers, images: images, videos: videos, leaderships: leaderships, users: users)

    else
    facilitys = Functions.facilitys_count(current_user)
    codes = Functions.codes_count(current_user)
    features = Functions.features_count(current_user)
    headers = Functions.headers_count(current_user)
    images = Functions.images_count(current_user)
    videos = Functions.videos_count(current_user)
    leaderships = Functions.leaderships_count(current_user)
    render(conn, "dashboard.html", facilitys: facilitys, codes: codes,features: features, headers: headers, images: images, videos: videos, leaderships: leaderships)
    end



  end
end
