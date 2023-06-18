defmodule Scadvert.Facilitys.Facility do
  use Ecto.Schema
  import Ecto.Changeset
  use Waffle.Ecto.Schema

  alias Scadvert.Accounts.User

  schema "facilitys" do
    field :status, :string
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
    |> cast(attrs, [:code, :name, :description,:status, :picture, :user_id])
    |> validate_required([:code, :name, :description, :status, :picture, :user_id])
  end
end
