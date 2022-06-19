defmodule WebshopRestaurant.UserContext do
  @moduledoc """
  The UserContext context.
  """

  import Ecto.Query, warn: false
  alias WebshopRestaurant.Repo

  alias WebshopRestaurant.UserContext.User

  defdelegate get_acceptable_roles(), to: User

  def authenticate_user(email, plain_text_password) do
    case Repo.get_by(User, email: email) do
      nil ->
        Pbkdf2.no_user_verify()
        {:error, :invalid_credentials}

      user ->
        if Pbkdf2.verify_pass(plain_text_password, user.hashed_password) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end
  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  alias WebshopRestaurantWeb.Services.Authenticator
  alias WebshopRestaurant.AuthToken
  
  def sign_in(email, password) do
    IO.inspect authenticate_user(email, password)
    case authenticate_user(email, password) do
      {:ok, user} ->
        token = Authenticator.generate_token(user.id)
        Repo.insert(Ecto.build_assoc(user, :auth_tokens, %{token: token}))
      {:error, :invalid_credentials} -> IO.puts "Error"
    end
  end
  
  def sign_out(conn) do
    case Authenticator.get_auth_token(conn) do
      {:ok, token} ->
        case Repo.get_by(AuthToken, %{token: token}) do
          nil -> {:error, :not_found}
          auth_token -> Repo.delete(auth_token)
        end
      error -> error
    end
  end
end
