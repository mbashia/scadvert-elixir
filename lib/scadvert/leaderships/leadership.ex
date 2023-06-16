defmodule Scadvert.Leaderships.Leadership do
  use Ecto.Schema
  import Ecto.Changeset

  schema "leaderships" do
    field :code, :integer
    field :description, :string
    field :name, :string
    field :status, :string
    field :picture, Scadvert.LeadershipImage.Type

    timestamps()
  end

  @doc false
  def changeset(leadership, attrs) do
    leadership
    |> cast(attrs, [:name, :description, :code, :status, :picture])
    |> validate_required([:name, :description, :code, :status, :picture])
  end
end
