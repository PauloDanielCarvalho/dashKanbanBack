defmodule Getaways.Repo.Migrations.AdicionarUserIdAProjects do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :user_id, references(:users), null: false
    end
  end
end
