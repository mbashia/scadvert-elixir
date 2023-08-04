defmodule Scadvert.Repo.Migrations.CreateFeedbacks do
  use Ecto.Migration

  def change do
    create table(:feedbacks) do
      add :name, :string
      add :message, :text
      add :email, :string
      add :code_id, references(:codes, on_delete: :nothing)

      timestamps()
    end

    create index(:feedbacks, [:code_id])
  end
end
