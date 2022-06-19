defmodule WebshopRestaurantWeb.UserView do
  use WebshopRestaurantWeb, :view
  alias WebshopRestaurant.UserContext.User

  def is_admin(conn) do
    with %User{id: user_id, role: "Admin"} <- conn.private.guardian_default_resource do
      true
    else
      _user -> false
    end
  end

  def loggedin(conn) do
    with true <- Map.has_key?(conn.private, :guardian_default_resource),
      %User{id: user_id} <- conn.private.guardian_default_resource do
        true
    else
      _user -> false
    end
  end
end
