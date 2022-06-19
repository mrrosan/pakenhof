defmodule WebshopRestaurant.ProductContext.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias WebshopRestaurant.CategoryContext.Category
  alias WebshopRestaurant.CartContext.Cart
  alias WebshopRestaurant.ProductCartContext.ProductCart
  alias WebshopRestaurant.OrderContext.Order
  alias WebshopRestaurant.OrderContext.OrderProduct


  schema "products" do
    field :description, :string
    field :name, :string
    field :price, :float
    field :quantity, :integer
    belongs_to :category, Category
    many_to_many :carts, Cart, join_through: ProductCart
    many_to_many :orders, Order, join_through: OrderProduct

  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :price, :description, :quantity, :category_id])
    |> validate_required([:name, :price, :description, :quantity, :category_id])
  end
end
