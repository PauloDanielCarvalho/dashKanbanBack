defmodule Getaways.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string
      add :description, :string
      add :creation_date, :date
      add :user_id, references(:users), null: false
      timestamps()
    end

  end
end
