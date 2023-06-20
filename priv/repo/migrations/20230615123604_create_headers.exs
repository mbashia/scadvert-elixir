defmodule Scadvert.Repo.Migrations.CreateHeaders do
  use Ecto.Migration

  def change do
    create table(:headers) do
      add :name, :string
      add :description, :text
      add :code_id, :integer
      add :status, :string
      add :picture, :string
      add :user_id, references(:users, on_delete: :nothing)


      timestamps()
    end
    create index(:headers, [:user_id])

  end
end
