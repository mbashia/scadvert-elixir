defmodule Scadvert.Repo.Migrations.CreateFacilitys do
  use Ecto.Migration

  def change do
    create table(:facilitys) do
      add :code, :integer
      add :name, :string
      add :description, :text
      add :active, :string
      add :picture, :string
      add :user_id, references(:users, on_delete: :nothing)


      timestamps()
    end
    create index(:facilitys, [:user_id])

  end
end
