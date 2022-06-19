defmodule WebshopRestaurantWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      WebshopRestaurantWeb.Telemetry,
      # Start the Endpoint (http/https)
      WebshopRestaurantWeb.Endpoint
      # Start a worker by calling: WebshopRestaurantWeb.Worker.start_link(arg)
      # {WebshopRestaurantWeb.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WebshopRestaurantWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    WebshopRestaurantWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
