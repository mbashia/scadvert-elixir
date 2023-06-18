defmodule Scadvert.Repo.Migrations.CreateFeatures do
  use Ecto.Migration

  def change do
    create table(:features) do
      add :name, :string
      add :description, :text
      add :code, :integer
      add :status, :string
      add :picture, :string
      add :user_id, references(:users, on_delete: :nothing)


      timestamps()
    end
    create index(:features, [:user_id])

  end
end
