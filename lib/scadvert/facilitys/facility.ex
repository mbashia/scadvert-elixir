defmodule Scadvert.Facilitys.Facility do
  use Ecto.Schema
  import Ecto.Changeset
  use Waffle.Ecto.Schema

  alias Scadvert.Accounts.User
  alias Scadvert.Codes.Code

  schema "facilitys" do
    field :status, :string
    # field :code, :integer
    field :description, :string
    field :name, :string
    field :picture, Scadvert.FacilityImage.Type
    belongs_to :user, User
    belongs_to :codes, Code, foreign_key: :code_id

    timestamps()
  end

  @doc false
  def changeset(facility, attrs) do
    facility
    |> cast(attrs, [:code_id, :name, :description, :status, :picture, :user_id])
    |> validate_required([:code_id, :name, :description, :status,  :user_id])
    |> validate_length(:description,  max: 500, message: "Description must be below 500 characters")

  end
end
