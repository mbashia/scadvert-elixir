defmodule Scadvert.Repo.Migrations.CreateFacilitys do
  use Ecto.Migration

  def change do
    create table(:facilitys) do
      add :code_id, :integer
      add :name, :string
      add :description, :text
      add :status, :string
      add :picture, :string
      add :user_id, references(:users, on_delete: :nothing)
      # add :codes_id, references(:codes, on_delete: :nothing)


      timestamps()
    end
    create index(:facilitys, [:user_id])
    # create index(:facilitys, [:codes_id])
  end
end
