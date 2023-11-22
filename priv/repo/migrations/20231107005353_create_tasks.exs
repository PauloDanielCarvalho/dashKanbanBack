defmodule Getaways.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string
      add :description, :string
      add :status, :string

      add :project_id, references(:projects), null: false
      timestamps()
    end

  end
end
