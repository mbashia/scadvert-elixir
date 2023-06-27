defmodule Scadvert.Headers.Header do
  use Ecto.Schema
  use Waffle.Ecto.Schema

  import Ecto.Changeset
  alias Scadvert.Accounts.User
  alias Scadvert.Codes.Code

  schema "headers" do
    # field :code, :integer
    field :description, :string
    field :name, :string
    field :status, :string
    field :picture, Scadvert.HeaderImage.Type
    belongs_to :user, User
    belongs_to :codes, Code, foreign_key: :code_id

    timestamps()
  end

  @doc false
  def changeset(header, attrs) do
    header
    |> cast(attrs, [:name, :description, :code_id, :status, :picture, :user_id])
    |> validate_required([:name, :description, :code_id, :status, :picture, :user_id])
  end
end
