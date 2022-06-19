defmodule WebshopRestaurantWeb.PageController do
  use WebshopRestaurantWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", role: "everyone")
  end

  def user_index(conn, _params) do
    render(conn, "index.html", role: "users")
  end

  def admin_index(conn, _params) do
    render(conn, "index.html", role: "admins")
  end

  def unauthenticatedApi(conn, _params) do
    json(conn,"Permission denied")
  end
end
