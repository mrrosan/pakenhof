defmodule WebshopRestaurant.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      WebshopRestaurant.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: WebshopRestaurant.PubSub}
      # Start a worker by calling: WebshopRestaurant.Worker.start_link(arg)
      # {WebshopRestaurant.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: WebshopRestaurant.Supervisor)
  end
end
