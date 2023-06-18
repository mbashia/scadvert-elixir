defmodule Scadvert.Headers.Header do
  use Ecto.Schema
  use Waffle.Ecto.Schema

  import Ecto.Changeset
  alias Scadvert.Accounts.User


  schema "headers" do
    field :code, :integer
    field :description, :string
    field :name, :string
    field :status, :string
    field :picture, Scadvert.HeaderImage.Type
    belongs_to :user, User


    timestamps()
  end

  @doc false
  def changeset(header, attrs) do
    header
    |> cast(attrs, [:name, :description, :code, :status, :picture, :user_id])
    |> validate_required([:name, :description, :code, :status, :picture, :user_id])
  end
end
