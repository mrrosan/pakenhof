defmodule WebshopRestaurantWeb.UserController do
  use WebshopRestaurantWeb, :controller

  alias WebshopRestaurant.UserContext
  alias WebshopRestaurant.UserContext.User

  def index(conn, _params) do
    users = UserContext.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = UserContext.change_user(%User{})
    roles = UserContext.get_acceptable_roles()
    IO.inspect(roles)
    render(conn, "new.html", changeset: changeset, acceptable_roles: roles)
  end

  def create(conn, %{"user" => user_params}) do
    roles = UserContext.get_acceptable_roles()

    case UserContext.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext("User created successfully."))
        # page to show after user is created
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, acceptable_roles: roles)
    end
  end

  def show(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    changeset = UserContext.change_user(user)
    roles = UserContext.get_acceptable_roles()
    render(conn, "edit.html", user: user, changeset: changeset, acceptable_roles: roles)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = UserContext.get_user!(id)
    roles = UserContext.get_acceptable_roles()

    case UserContext.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext("User updated successfully."))
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset, acceptable_roles: roles)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    {:ok, _user} = UserContext.delete_user(user)

    conn
    |> put_flash(:info, gettext("User deleted successfully."))
    |> redirect(to: Routes.user_path(conn, :index))
  end
end
