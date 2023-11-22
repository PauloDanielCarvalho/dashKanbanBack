defmodule Getaways.Kanban.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :name, :string
    field :status, :string, default: "to-do"
    field :description, :string

    belongs_to :project, Getaways.Kanban.Project
    has_many :comments, Getaways.Kanban.Comment
    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :description, :status, :project_id])
    |> validate_required([:name, :description, :status, :project_id])
    |> validate_inclusion(:status, ["to-do", "in-progress", "done"])
    |> assoc_constraint(:project)
  end
end
