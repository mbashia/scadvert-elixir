defmodule Scadvert.Facilitys.Facility do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scadvert.Accounts.User

  schema "facilitys" do
    field :active, :string
    field :code, :integer
    field :description, :string
    field :name, :string
    field :picture, Scadvert.FacilityImage.Type
    belongs_to :user, User


    timestamps()
  end

  @doc false
  def changeset(facility, attrs) do
    facility
    |> cast(attrs, [:code, :name, :description, :active, :picture, :user_id])
    |> validate_required([:code, :name, :description, :active, :picture, :user_id])
  end
end
