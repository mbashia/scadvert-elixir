defmodule Scadvert.Repo.Migrations.CreateCodes do
  use Ecto.Migration

  def change do
    create table(:codes) do
      add :name, :bigint
      add :description, :text
      add :active, :string
      add :picture, :string
      add :type, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:codes, [:user_id])
    create unique_index(:codes, [:name])
  end
end
