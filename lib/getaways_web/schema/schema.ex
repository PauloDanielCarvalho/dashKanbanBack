defmodule GetawaysWeb.Schema.Schema do
  use Absinthe.Schema


  import_types Absinthe.Type.Custom
  alias Getaways.{Accounts, Kanban}
  import Absinthe.Resolution.Helpers, only: [dataloader: 1, dataloader: 3]
  alias GetawaysWeb.Resolvers
  alias GetawaysWeb.Schema.Middleware

  query do
    @desc "Get the currently signed-in user"
    field :me, :user do
      resolve &Resolvers.Accounts.me/3
    end

    @desc "Get a list of projects based on user ID."
    field :projects, list_of(:project) do
      arg :limit, :integer
      arg :filter, :project_filter
      middleware Middleware.Authenticate
      resolve &Resolvers.Kanban.project/3
    end

    @desc "Get a list of task based on project_id."
    field :tasks, list_of(:task) do
      arg :project_id, non_null(:id)
      middleware Middleware.Authenticate
      resolve &Resolvers.Kanban.get_tasks/3
    end

  end

  mutation do
    @desc "change task status"
    field :change_task, :task do
      arg :task_id, non_null(:id)
      arg :new_status, non_null(:string)
      middleware Middleware.Authenticate
      resolve &Resolvers.Kanban.change_status_task/3
    end

    @desc "Create a user account"
    field :signup, :session do
      arg :name, non_null(:string)
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      resolve &Resolvers.Accounts.signup/3
    end

    @desc "Sign in a user"
    field :signin, :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      resolve &Resolvers.Accounts.signin/3
    end

    @desc "Create project"
    field :create_project, :project do
      arg :name, non_null(:string)
      arg :description, non_null(:string)
      arg :creation_date, non_null(:string)

      middleware Middleware.Authenticate
      resolve &Resolvers.Kanban.create_project/3

    end

    @desc "Create task for a project"
    field :create_task, :task do
      arg :name, non_null(:string)
      arg :status, non_null(:string)
      arg :description, non_null(:string)
      arg :project_id, non_null(:id)
      middleware Middleware.Authenticate
      resolve  &Resolvers.Kanban.create_task/3

    end

    @desc "Create comment for a task"
    field :create_comment, :comment do
      arg :content, non_null(:string)
      arg :creation_date, non_null(:date)
      arg :task_id, non_null(:id)
      middleware Middleware.Authenticate
      resolve  &Resolvers.Kanban.create_comment/3
    end
  end

  subscription do
    @desc "Subscribe to task changes status"
    field :task_change, :task do
      arg :project_id, non_null(:id)

      config fn args, _res ->
        {:ok, topic: args.project_id}
      end
    end
  end

  object :user do
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :password, non_null(:string)
  end
  object :session do
    field :user, non_null(:user)
    field :token, non_null(:string)
  end

  object :project do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :description, non_null(:string)
    field :creation_date, non_null(:date)
    field :tasks, list_of(:task), resolve: dataloader(Kanban)

  end

  object :task do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :status, non_null(:string)
    field :description, non_null(:string)
    field :creation_date, non_null(:date)
    field :date_conclusion, non_null(:date)
    field :comments, list_of(:comment), resolve: dataloader(Kanban)

  end

  object :comment do
    field :id, non_null(:id)
    field :content, non_null(:string)
    field :creation_date, non_null(:date)
  end

  @desc "Filters for the list of project"
  input_object :project_filter do
    @desc "Matching a name, location, or description"
    field :matching, :string

    @desc "Filter by creation date"
    field :created_at, :date
  end

  def context(ctx) do
    loader =
      Dataloader.new
      |> Dataloader.add_source(Kanban, Kanban.datasource())


    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
