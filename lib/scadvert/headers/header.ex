defmodule Scadvert.Headers.Header do
  use Ecto.Schema
  use  Waffle.Ecto.Schema

  import Ecto.Changeset

  schema "headers" do
    field :code, :integer
    field :description, :string
    field :name, :string
    field :status, :string
    field :picture, Scadvert.HeaderImage.Type


    timestamps()
  end

  @doc false
  def changeset(header, attrs) do
    header
    |> cast(attrs, [:name, :description, :code, :status,:picture])
    |> validate_required([:name, :description, :code, :status,:picture])
  end
end
