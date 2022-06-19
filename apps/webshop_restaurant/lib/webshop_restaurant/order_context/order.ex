defmodule WebshopRestaurant.OrderContext.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias WebshopRestaurant.UserContext.User
  alias WebshopRestaurant.ProductContext.Product
  alias WebshopRestaurant.OrderContext.OrderProduct

  schema "orders" do
    field :total_price, :float
    many_to_many :products, Product, join_through: OrderProduct
    belongs_to :user, User


    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:total_price, :user_id])
    |> validate_required([:total_price, :user_id])
  end
end
