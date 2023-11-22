defmodule Getaways.Accounts do
  @moduledoc """
  The Accounts context: public interface for account functionality.
  """

  import Ecto.Query, warn: false
  alias Getaways.Repo

  alias Getaways.Accounts.User


  def get_user(id) do
    Repo.get(User, id)
  end

  @doc """
  Creates a user.
  """
  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Authenticates a user.

  Returns `{:ok, user}` if a user exists with the given username
  and the password is valid. Otherwise, `:error` is returned.
  """
  def authenticate(email, password) do
    user = Repo.get_by(User, email: email)

    with %{password_hash: password_hash} <- user,
         true <- Pbkdf2.verify_pass(password, password_hash) do
      {:ok, user}
    else
      _ -> :error
    end
  end


end
