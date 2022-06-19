defmodule WebshopRestaurantWeb.Router do
  use WebshopRestaurantWeb, :router

  pipeline :allowed_for_users do
    plug WebshopRestaurantWeb.Plugs.AuthorizationPlug, ["Admin", "User"]
  end

  pipeline :allowed_for_admins do
    plug WebshopRestaurantWeb.Plugs.AuthorizationPlug, ["Admin"]
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug WebshopRestaurantWeb.Plugs.Locale
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug WebshopRestaurantWeb.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :apiAuth do
    plug WebshopRestaurantWeb.Plug.ApiAuthorization
  end

  scope "/", WebshopRestaurantWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout
    get "/signup", SessionController, :signup
    post "/signup", SessionController, :signup_user
    get "/unauthenticatedApi", PageController, :unauthenticatedApi
  end

  scope "/", WebshopRestaurantWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_users]

    get "/user_scope", PageController, :user_index
    resources "/products", ProductController, only: [:index, :show]
    resources "/carts", CartController
    get "/add_cart/:id", CartController, :add_cart
    get "/delete_product/:id", CartController, :delete_product
    get "/create_order", OrderController, :create_order
    get "/my_orders", OrderController, :my_orders
    resources "/orders", OrderController, only: [:show]
    get "/discount_code", CartController, :discount_form
    post "/discount_code", CartController, :apply_discount

  end

  scope "/admin", WebshopRestaurantWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_admins]

    resources "/users", UserController
    resources "/orders", OrderController
    resources "/categories", CategoryController
    resources "/products", ProductController
    get "/", PageController, :admin_index
    get "/create_order", OrderController, :create_order
    get "/all_orders", OrderController, :index
  end

   scope "/api", WebshopRestaurantWeb do
    post "/sign_in", SessionController, :create
    delete "/sign_out", SessionController, :delete
    pipe_through [:api, :apiAuth]
    resources "/products", Api.ProductController

  #    resources "/products", ProductController
  #  end
  end

  # Other scopes may use custom stacks.
  # scope "/api", WebshopRestaurantWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: WebshopRestaurantWeb.Telemetry
    end
  end
end
