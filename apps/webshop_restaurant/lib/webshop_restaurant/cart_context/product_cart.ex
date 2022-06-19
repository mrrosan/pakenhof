defmodule WebshopRestaurant.ProductCartContext.ProductCart do
    use Ecto.Schema
    import Ecto.Changeset

    alias WebshopRestaurant.CartContext.Cart
    alias WebshopRestaurant.ProductContext.Product

    schema "products_carts" do
        belongs_to :cart, Cart
        belongs_to :product, Product
      end
    
      @doc false
      def changeset(product_cart, attrs) do
        product_cart
        |> cast(attrs, [:cart_id, :product_id])
        |> validate_required([:cart_id, :product_id])
        |> foreign_key_constraint(:cart_id)
        |> foreign_key_constraint(:product_id)
      end
  end
  