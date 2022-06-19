defmodule WebshopRestaurant.CartContext.Cart do
  use Ecto.Schema
  import Ecto.Changeset

  alias WebshopRestaurant.ProductContext.Product
  alias WebshopRestaurant.UserContext.User
  alias WebshopRestaurant.ProductCartContext.ProductCart

  schema "carts" do
    field :number_of_products, :integer
    field :total_price, :float
    field :discount_code, :boolean, default: false
    many_to_many :products, Product, join_through: ProductCart
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(cart, attrs) do
    IO.puts "----------------------------------------------------------------------"
    IO.inspect attrs
    cart
    |> cast(attrs, [:number_of_products, :total_price, :discount_code, :user_id])
  end

end
