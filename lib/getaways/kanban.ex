defmodule Getaways.Kanban do
  @moduledoc """

  """

  import Ecto.Query, warn: false
  alias Getaways.Repo
  alias Getaways.Kanban.Project
  alias Getaways.Accounts.User
  alias Getaways.Kanban.Task
  alias Getaways.Kanban.Comment

  def create_project(%User{} = user, attrs) do
    %Project{}
    |> Project.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  def create_task(attrs) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  def create_comment(attrs) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  def get_projects(id, criteria) do
    query = from(p in Project, where: p.user_id == ^id)
    Enum.reduce(criteria, query, fn
      {:limit, limit}, query ->
        from p in query, limit: ^limit
      {:filter, filters}, query ->
        filter_with(filters, query)
    end)
    |> Repo.all
  end


  defp filter_with(filters, query) do
    Enum.reduce(filters, query, fn
      {:matching, term}, query ->
        pattern = "%#{term}%"

        from q in query,
          where:
            ilike(q.name, ^pattern) or
              ilike(q.description, ^pattern)

      {:created_at, value}, query ->
        from q in query, where: q.creation_date >= ^value


    end)
  end

  def get_tasks_for_project(project_id) do
    case Repo.all(from(p in Task, where: p.project_id == ^project_id)) do
      [] ->
        {:error}
      tasks ->
        {:ok, tasks}
    end
  end

  def change_task(args) do
    case Repo.get(Task, args.task_id) do
      %Task{} = task ->
        changeset = Task.changeset(task, %{status: args.new_status})
        Repo.update(changeset)
      end
  end


  # Dataloader
  def datasource() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end
  def query(queryable, _) do
    queryable
  end

end
