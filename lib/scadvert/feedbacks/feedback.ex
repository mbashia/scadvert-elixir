defmodule Scadvert.Feedbacks.Feedback do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scadvert.Codes.Code

  schema "feedbacks" do
    field :email, :string
    field :message, :string
    field :name, :string
    belongs_to :code, Code

    timestamps()
  end

  @spec changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(feedback, attrs) do
    feedback
    |> cast(attrs, [:name, :message, :email, :code_id])
    |> validate_required([:name, :message, :email, :code_id])
  end
end
