defmodule Scadvert.Images.Image do
  use Ecto.Schema
  import Ecto.Changeset
  use Waffle.Ecto.Schema

  alias Scadvert.Accounts.User

  schema "images" do
    field :code, :integer
    field :description, :string
    field :name, :string
    field :status, :string
    field :picture, Scadvert.ImageImage.Type
    belongs_to :user, User


    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:name, :description, :code, :status, :picture, :user_id])
    |> validate_required([:name, :description, :code, :status, :picture, :user_id])
  end
end
