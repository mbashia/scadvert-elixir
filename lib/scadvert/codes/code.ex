defmodule Scadvert.Codes.Code do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset
  alias Scadvert.Accounts.User

  schema "codes" do
    field :active, :string
    field :description, :string
    field :name, :integer
    field :picture, Scadvert.CodeImage.Type
    field :type, :string
    belongs_to :user, User


    timestamps()
  end

  @doc false
  def changeset(code, attrs) do
    code
    |> cast(attrs, [:active, :description, :name, :picture, :type, :user_id])
    # |> cast(attrs, [:name, :description, :active])

    |> validate_required([:name, :description, :active, :picture, :type, :user_id])
  end
end
