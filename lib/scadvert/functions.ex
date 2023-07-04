defmodule Scadvert.Functions do
  import Ecto.Query
  import Ecto.Query, warn: false

  alias Scadvert.Repo
  alias Scadvert.Codes.Code
  alias Scadvert.Facilitys.Facility
  alias Scadvert.Headers.Header
  alias Scadvert.Features.Feature
  alias Scadvert.Images.Image
  alias Scadvert.Leaderships.Leadership
  alias Scadvert.Videos.Video
  alias Scadvert.Accounts.User


  def list_codes(conn) do
    user_id = conn.assigns.current_user.id
    Repo.all(from p in Code, where: p.user_id == ^user_id, select: {p.name, p.id})
  end
 
  def get_user_by_id(conn) do
    user_id = conn.assigns.current_user.id
    Repo.one(from u in User, where: u.id == ^user_id, select: %{id: u.id,firstname: u.firstname, lastname: u.lastname, gender: u.gender, picture: u.picture, email: u.email, contact: u.phone_number})
  end
  def facilitys_count(current_user)do
    Repo.one(from(f in Facility, where: f.user_id == ^current_user.id , select: count(f.id) ))

  end
  def codes_count(current_user)do
    Repo.one(from(c in Code, where: c.user_id == ^current_user.id , select: count(c.id) ))

  end
  def headers_count(current_user)do
    Repo.one(from(h in Header, where: h.user_id == ^current_user.id, select: count(h.id) ))
  end
  def features_count(current_user)do
    Repo.one(from(f in Feature, where: f.user_id == ^current_user.id, select: count(f.id) ))
  end
  def images_count(current_user)do
    Repo.one(from(i in Image, where: i.user_id == ^current_user.id, select: count(i.id) ))
  end
  def leaderships_count(current_user)do
    Repo.one(from(l in Leadership, where: l.user_id == ^current_user.id, select: count(l.id) ))
  end
  def videos_count(current_user)do
    Repo.one(from(v in Video, where: v.user_id == ^current_user.id, select: count(v.id) ))
  end
  def users_count()do
    Repo.one(from(u in User, select: count(u.id)))
  end




end
