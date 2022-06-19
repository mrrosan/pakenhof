defmodule WebshopRestaurantWeb.Plug.ApiAuthorization do
    use WebshopRestaurantWeb, :controller
      import Plug.Conn
      alias WebshopRestaurant.UserContext.User
      alias Phoenix.Controller
      alias WebshopRestaurantWeb.Services.Authenticator
      alias WebshopRestaurant.AuthTokenContext
  
      def init(options), do: options
  
      def call(conn, _options) do
            case Authenticator.get_auth_token(conn) do #retrieve key
                {:ok, key} ->
                    grant_access(conn, true) #grant access to application
                {:error, invalid} ->
                    Controller.redirect(conn, to: "/unauthenticatedApi") #bij errors, bijv. foute key meegegeven.
                end
      end
  
      def grant_access(conn, true), do: conn
  
      def grant_access(conn, false) do
        conn
        |> Controller.redirect(to: "/unauthenticatedApi") #show in JSON
        |> halt
      end
  end
  