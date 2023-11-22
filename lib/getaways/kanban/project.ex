defmodule Getaways.Kanban.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :name, :string
    field :description, :string
    field :creation_date, :date

    belongs_to :user, Getaways.Accounts.User
    has_many :tasks, Getaways.Kanban.Task
    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name, :description, :creation_date])
    |> validate_required([:name, :description, :creation_date])
    |>assoc_constraint(:user)
  end
end
