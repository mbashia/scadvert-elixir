defmodule Scadvert.Features.Feature do
  use Ecto.Schema
  import Ecto.Changeset

  schema "features" do
    field :code, :integer
    field :description, :string
    field :name, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(feature, attrs) do
    feature
    |> cast(attrs, [:name, :description, :code, :status])
    |> validate_required([:name, :description, :code, :status])
  end
end
