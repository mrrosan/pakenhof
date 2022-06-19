defmodule WebshopRestaurantWeb.OrderController do
  use WebshopRestaurantWeb, :controller

  alias WebshopRestaurant.OrderContext
  alias WebshopRestaurant.OrderContext.Order
  alias WebshopRestaurant.CartContext
  alias WebshopRestaurant.ProductContext

  def index(conn, _params) do
    orders = OrderContext.list_orders()
    render(conn, "index.html", orders: orders)
  end

  def my_orders(conn, _params) do
    user =  conn.private.guardian_default_resource
    orders = OrderContext.list_orders(user.id)
    render(conn, "index.html", orders: orders)

  end

  def show(conn, %{"id" => id}) do
    order = OrderContext.get_order!(id)
    user = order.user
    products = fetch_products(OrderContext.list_order_product(order.id))
    render(conn, "show.html", order: order, user: user, products: products)
  end

  def delete(conn, %{"id" => id}) do
    order = OrderContext.get_order!(id)
    {:ok, _order} = OrderContext.delete_order(order)

    conn
    |> put_flash(:info, "Order deleted successfully.")
    |> redirect(to: Routes.order_path(conn, :index))
  end

  def create_order(conn, _params) do
    user =  conn.private.guardian_default_resource
    {:ok, cart} = CartContext.get_or_create_cart(user.id)
    products_carts = CartContext.list_product_cart(cart.id)
    products = fetch_products(products_carts)
    total_price = order_total(products)
    {:ok, order} = OrderContext.create_order(%{total_price: total_price, user_id: user.id})
    Enum.map(products, fn product -> 
      OrderContext.create_order_product(%{order_id: order.id, product_id: product.id})
      ProductContext.update_product(product, %{quantity: product.quantity - 1})
      CartContext.delete_cart_product(product.id, cart.id)
    end)
    CartContext.update_cart(cart, %{number_of_products: 0, total_price: 0}
    )
    conn
    |> put_flash(:info, gettext("Order created successfully."))
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp fetch_products([]) do
    []
  end

  defp fetch_products(cart_products) do
    products =
      Enum.map(cart_products, fn product_cart ->
        product_cart.product
      end)
  end

  defp order_total([]) do
    0
  end

  # return total items + price
  defp order_total(products) do
    prices =
      Enum.map(products, fn product ->
        product.price
      end)

    Enum.reduce(prices, fn price, acc ->
      price + acc
    end)
  end


end
