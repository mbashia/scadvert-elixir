defmodule Scadvert.Repo.Migrations.CreateLeaderships do
  use Ecto.Migration

  def change do
    create table(:leaderships) do
      add :name, :string
      add :description, :text
      add :code, :integer
      add :status, :string
      add :picture, :string
      add :user_id, references(:users, on_delete: :nothing)


      timestamps()
    end
    create index(:leaderships, [:user_id])

  end
end
