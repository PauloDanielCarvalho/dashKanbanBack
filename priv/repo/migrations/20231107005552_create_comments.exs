defmodule Getaways.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :string
      add :creation_date, :date

      add :task_id, references(:tasks), null: false
      timestamps()
    end

  end
end
