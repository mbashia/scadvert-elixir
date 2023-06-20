defmodule Scadvert.Features.Feature do
  use Ecto.Schema
  import Ecto.Changeset
  use Waffle.Ecto.Schema

  alias Scadvert.Accounts.User
  alias Scadvert.Codes.Code


  schema "features" do
    # field :code, :integer
    field :description, :string
    field :name, :string
    field :status, :string
    field :picture, Scadvert.FeatureImage.Type
    belongs_to :user, User
    belongs_to :codes, Code, foreign_key: :code


    timestamps()
  end

  @doc false
  def changeset(feature, attrs) do
    feature
    |> cast(attrs, [:name, :description, :code, :status, :picture, :user_id])
    |> validate_required([:name, :description, :code, :status, :picture, :user_id])
  end
end
