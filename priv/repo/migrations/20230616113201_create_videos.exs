defmodule Scadvert.Repo.Migrations.CreateVideos do
  use Ecto.Migration

  def change do
    create table(:videos) do
      add :name, :string
      add :description, :text
      add :code, :integer
      add :status, :string

      timestamps()
    end
  end
end
