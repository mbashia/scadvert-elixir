defmodule Scadvert.Videos.Video do
  use Ecto.Schema
  import Ecto.Changeset

  schema "videos" do
    field :code, :integer
    field :description, :string
    field :name, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:name, :description, :code, :status])
    |> validate_required([:name, :description, :code, :status])
  end
end
