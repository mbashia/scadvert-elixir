defmodule Scadvert.Leaderships.Leadership do
  use Ecto.Schema
  import Ecto.Changeset
  use Waffle.Ecto.Schema

  alias Scadvert.Accounts.User
  alias Scadvert.Codes.Code

  schema "leaderships" do
    # field :code, :integer
    field :description, :string
    field :name, :string
    field :status, :string
    field :picture, Scadvert.LeadershipImage.Type
    belongs_to :user, User
    belongs_to :codes, Code, foreign_key: :code_id

    timestamps()
  end

  @doc false
  def changeset(leadership, attrs) do
    leadership
    |> cast(attrs, [:name, :description, :code_id, :status, :picture, :user_id])
    |> validate_required([:name, :description, :code_id, :status, :picture, :user_id])
  end
end
