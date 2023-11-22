defmodule Getaways.Kanban.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :string
    field :creation_date, :date

    belongs_to :task, Getaways.Kanban.Task
    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :creation_date, :task_id])
    |> validate_required([:content, :creation_date, :task_id])
    |> assoc_constraint(:task)
  end
end
