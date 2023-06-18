defmodule Scadvert.Videos.Video do
  use Ecto.Schema
  import Ecto.Changeset
  use Waffle.Ecto.Schema

  alias Scadvert.Accounts.User


  schema "videos" do
    field :code, :integer
    field :description, :string
    field :name, :string
    field :status, :string
    belongs_to :user, User
    field :video, Scadvert.FileVideo.Type



    timestamps()
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:name, :description, :code, :status,:video, :user_id])
    |> validate_required([:name, :description, :code, :status,:video, :user_id])
  end
end
