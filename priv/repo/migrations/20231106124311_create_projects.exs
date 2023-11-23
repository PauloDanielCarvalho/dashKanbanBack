defmodule Getaways.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string
      add :description, :string
      add :creation_date, :date

      timestamps()
    end

  end
end
