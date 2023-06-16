defmodule Scadvert.Images.Image do
  use Ecto.Schema
  import Ecto.Changeset

  schema "images" do
    field :code, :integer
    field :description, :string
    field :name, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:name, :description, :code, :status])
    |> validate_required([:name, :description, :code, :status])
  end
end
