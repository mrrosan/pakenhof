defmodule WebshopRestaurant.Repo do
  use Ecto.Repo,
    otp_app: :webshop_restaurant,
    adapter: Ecto.Adapters.MyXQL
end
