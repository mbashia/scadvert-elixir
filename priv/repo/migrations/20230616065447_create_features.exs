defmodule Scadvert.Repo.Migrations.CreateFeatures do
  use Ecto.Migration

  def change do
    create table(:features) do
      add :name, :string
      add :description, :text
      add :code, :integer
      add :status, :string
      add :picture, :string

      timestamps()
    end
  end
end
