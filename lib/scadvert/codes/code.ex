defmodule Scadvert.Codes.Code do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset
  alias Scadvert.Accounts.User
  alias Scadvert.Facilitys.Facility
  alias Scadvert.Features.Feature
  alias Scadvert.Headers.Header
  alias Scadvert.Images.Image
  alias Scadvert.Leaderships.Leadership
  alias Scadvert.Videos.Video

  schema "codes" do
    field :active, :string
    field :description, :string
    field :name, :integer
    field :picture, Scadvert.CodeImage.Type
    field :type, :string
    belongs_to :user, User
    has_many :facilitys, Facility
    has_many :features, Feature
    has_many :headers, Header
    has_many :images, Image
    has_many :leaderships, Leadership
    has_many :videos, Video

    timestamps()
  end

  @doc false
  def changeset(code, attrs) do
    code
    |> cast(attrs, [:active, :description, :name, :picture, :type, :user_id])
    # |> cast(attrs, [:name, :description, :active])

    |> validate_required([:name, :description, :active, :picture, :type, :user_id])
  end
end
