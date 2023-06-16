defmodule Scadvert.Repo.Migrations.CreateCodes do
  use Ecto.Migration

  def change do
    create table(:codes) do
      add :name, :integer
      add :description, :text
      add :active, :string
      add :picture, :string
      add :type, :string

      timestamps()
    end
  end
end
