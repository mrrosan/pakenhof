defmodule WebshopRestaurant.AuthTokenContext do
    @moduledoc """
    The CartContext context.
    """
  
    import Ecto.Query, warn: false
    alias WebshopRestaurant.Repo
  
    alias WebshopRestaurant.AuthTokenContext
    alias WebshopRestaurant.AuthToken


    def get_key_by_user_id(user_id) do
        case Repo.get_by(AuthToken, user_id: user_id) do
            nil ->
              {:error}
            auth_token ->
              {:ok, auth_token}
          end
        end

end
  