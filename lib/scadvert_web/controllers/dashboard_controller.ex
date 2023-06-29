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
    codes = Functions.codes_count(current_user)
    features = Functions.features_count(current_user)
    headers = Functions.headers_count(current_user)
    images = Functions.images_count(current_user)
    videos = Functions.videos_count(current_user)
    leaderships = Functions.leaderships_count(current_user)

    render(conn, "dashboard.html", facilitys: facilitys, codes: codes,features: features, headers: headers, images: images, videos: videos, leaderships: leaderships)


  end
end
