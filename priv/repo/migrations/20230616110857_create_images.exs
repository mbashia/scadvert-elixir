defmodule Scadvert.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :name, :string
      add :description, :text
      add :code_id, :integer
      add :status, :string
      add :picture, :string
      add :user_id, references(:users, on_delete: :nothing)


      timestamps()
    end
    create index(:images, [:user_id])

  end
end
