defmodule Scadvert.Functions do
  import Ecto.Query
  import Ecto.Query, warn: false

  alias Scadvert.Repo
  alias Scadvert.Codes.Code
  alias Scadvert.Facilitys.Facility
  alias Scadvert.Headers.Header
  alias Scadvert.Features.Features
  alias Scadvert.Images.Image
  alias Scadvert.Leaderships.Leadership
  alias Scadvert.Videos.Video
  alias Scadvert.Users.User


  def list_codes(conn) do
    user_id = conn.assigns.current_user.id
    Repo.all(from p in Code, where: p.user_id == ^user_id, select: {p.name, p.id})
  end
  def facilitys_count(current_user)do
    Repo.one(from(f in Facility, where: f.user_id == ^current_user.id , select: count(f.id) ))

  end

end
