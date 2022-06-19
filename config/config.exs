# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

config :webshop_restaurant_web, WebshopRestaurantWeb.Gettext,
  locales: ~w(en nl), 
  default_locale: "en"

# Configure Mix tasks and generators
config :webshop_restaurant,
  ecto_repos: [WebshopRestaurant.Repo]

config :webshop_restaurant_web,
  ecto_repos: [WebshopRestaurant.Repo],
  generators: [context_app: :webshop_restaurant]

config :webshop_restaurant_web, WebshopRestaurantWeb.Guardian,
  issuer: "webshop_restaurant_web",
  secret_key: "QilIxm841sdr6tPIU8wTq4+WwPH0q25uskluazcNOqlYW4glRf6Bh646FAzcvb75"

# Configures the endpoint
config :webshop_restaurant_web, WebshopRestaurantWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Mf4e8GsnI9gb8EvugMDzDjbo+QtZ4ok+E91DLioXQH5rS8SAwA8PZ3lbY1U6Jd0c",
  render_errors: [view: WebshopRestaurantWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: WebshopRestaurant.PubSub,
  live_view: [signing_salt: "NWupNiel"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
