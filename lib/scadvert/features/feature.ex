defmodule Scadvert.Features.Feature do
  use Ecto.Schema
  import Ecto.Changeset

  schema "features" do
    field :code, :integer
    field :description, :string
    field :name, :string
    field :status, :string
    field :picture, Scadvert.FeatureImage.Type

    timestamps()
  end

  @doc false
  def changeset(feature, attrs) do
    feature
    |> cast(attrs, [:name, :description, :code, :status, :picture])
    |> validate_required([:name, :description, :code, :status, :picture])
  end
end
