defmodule WebshopRestaurantWeb.SessionController do
  use WebshopRestaurantWeb, :controller

  alias WebshopRestaurantWeb.Guardian
  alias WebshopRestaurant.UserContext
  alias WebshopRestaurant.UserContext.User

  require IEx

  def new(conn, _) do
    changeset = UserContext.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      redirect(conn, to: "/user_scope")
    else
      render(conn, "new.html", changeset: changeset, action: Routes.session_path(conn, :login))
    end
  end

  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    UserContext.authenticate_user(email, password)
    |> login_reply(conn)
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/login")
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, gettext("Welcome back!"))
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/user_scope")
  end

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> new(%{})
  end

  def signup(conn, _) do
    changeset = UserContext.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      redirect(conn, to: "/user_scope")
    else
      render(conn, "signup.html",
        changeset: changeset,
        action: Routes.session_path(conn, :signup_user)
      )
    end
  end

  def signup_user(conn, %{"user" => user_params}) do
    case UserContext.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext("User created successfully."))
        |> redirect(to: "/login")

      {:error, %Ecto.Changeset{} = changeset} ->
        # roles = UserContext.get_acceptable_roles()
        IO.inspect(changeset)

        render(conn, "signup.html",
          changeset: changeset,
          action: Routes.session_path(conn, :signup_user)
        )
    end
  end

  def create(conn, %{"email" => email, "password" => password}) do
    case UserContext.sign_in(email, password) do
      {:ok, auth_token} ->
        conn
        |> put_status(:ok)
        |> render("show.json", %{token: auth_token.token})
      {:error, reason} ->
        conn
        |> send_resp(401, reason)
    end
  end

  
  def delete(conn, _) do
    case UserContext.sign_out(conn) do
      {:error, reason} -> conn |> send_resp(400, reason)
      {:ok, _} -> conn |> send_resp(204, "")
    end
  end
end
