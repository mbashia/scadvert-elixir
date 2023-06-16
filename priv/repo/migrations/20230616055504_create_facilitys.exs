defmodule Scadvert.Repo.Migrations.CreateFacilitys do
  use Ecto.Migration

  def change do
    create table(:facilitys) do
      add :code, :integer
      add :name, :string
      add :description:text
      add :active, :string
      add :picture, :string


      timestamps()
    end
  end
end
