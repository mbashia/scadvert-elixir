defmodule Scadvert.Repo.Migrations.CreateVideos do
  use Ecto.Migration

  def change do
    create table(:videos) do
      add :name, :string
      add :description, :text
      add :code, :integer
      add :status, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :video, :string


      timestamps()
    end
    create index(:videos, [:user_id])

  end
end
