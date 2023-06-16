defmodule Scadvert.Facilitys.Facility do
  use Ecto.Schema
  import Ecto.Changeset

  schema "facilitys" do
    field :active, :string
    field :code, :integer
    field :description, :string
    field :name, :string
    field :picture, Scadvert.FacilityImage.Type


    timestamps()
  end

  @doc false
  def changeset(facility, attrs) do
    facility
    |> cast(attrs, [:code, :name, :description, :active,:picture])
    |> validate_required([:code, :name, :description, :active,:picture])
  end
end
