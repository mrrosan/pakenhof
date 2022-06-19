defmodule WebshopRestaurant.OrderContext.OrderProduct do
    use Ecto.Schema
    import Ecto.Changeset

    alias WebshopRestaurant.OrderContext.Order
    alias WebshopRestaurant.ProductContext.Product

    schema "orders_products" do
        belongs_to :order, Order
        belongs_to :product, Product
      end
    
      @doc false
      def changeset(order_product, attrs) do
        order_product
        |> cast(attrs, [:order_id, :product_id])
        |> validate_required([:order_id, :product_id])
        |> foreign_key_constraint(:order_id)
        |> foreign_key_constraint(:product_id)
      end
  end