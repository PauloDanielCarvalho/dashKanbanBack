defmodule GetawaysWeb.Resolvers.Kanban do
  alias Getaways.Kanban
  alias GetawaysWeb.Schema.ChangesetErrors

  def create_project(_, args, %{context: %{current_user: user}}) do
    case Kanban.create_project(user, args) do
      {:error, changeset} ->
        {:error,
         message: "Could not create project",
         details: ChangesetErrors.error_details(changeset)
        }

      {:ok, project} ->
        {:ok, project}
    end
  end

  def create_task(_, args, _) do
    case Kanban.create_task(args) do
      {:error, changeset} ->
        {:error,
         message: "Could not create task!",
         details: ChangesetErrors.error_details(changeset)
        }

      {:ok, task} ->
        publish_task_change(task)
        {:ok, task}
    end
  end
  def create_comment(_, args, _) do
    case Kanban.create_comment(args) do
      {:error, changeset} ->
        {:error,
         message: "Could not create comment!",
         details: ChangesetErrors.error_details(changeset)
        }

      {:ok, comment} ->
        {:ok, comment}
    end
  end

  def project(_,args, %{context: %{current_user: user}}) do
    {:ok, Kanban.get_projects(user.id,args)}
  end

  def change_status_task(_, args, _) do
    case Kanban.change_task(args) do
      {:ok, task} ->
        publish_task_change(task)
        {:ok, task}

      {:error, error} ->
        {:error, error}
    end
  end

  def get_tasks(_, args, _) do
    case Kanban.get_tasks_for_project(args.project_id) do
      {:error, changeset} ->
        {:error,
         message: "Could not create comment!",
         details: ChangesetErrors.error_details(changeset)
        }

      {:ok, tasks} ->
        {:ok, tasks}
    end
  end
  defp publish_task_change(project) do
    Absinthe.Subscription.publish(
      GetawaysWeb.Endpoint,
      project,
      task_change: project.project_id
    )
  end

end
