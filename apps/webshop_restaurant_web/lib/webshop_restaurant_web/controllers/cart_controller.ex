defmodule WebshopRestaurantWeb.CartController do
  use WebshopRestaurantWeb, :controller

  alias WebshopRestaurant.CartContext
  alias WebshopRestaurant.CartContext.Cart
  alias WebshopRestaurant.UserContext.User

  def index(conn, _params) do
    user =  conn.private.guardian_default_resource
    {:ok, cart} = CartContext.get_or_create_cart(user.id)
    products_carts = CartContext.list_product_cart(cart.id)
    products = fetch_products(products_carts)
    render(conn, "show.html", cart: cart, products: products)
  end

  def show(conn, %{"id" => id}) do
    # fetch products_carts and preload products to get product id
    # [{product_cart{product: %{product}}}]
    products_carts = CartContext.list_product_cart(id)
    products = fetch_products(products_carts)
    cart = CartContext.get_cart!(id)
    render(conn, "show.html", cart: cart, products: products)
  end

  def discount_form(conn, _) do
    changeset = CartContext.change_cart(%Cart{})
    IO.puts "_________________________________________________"
    IO.inspect changeset
    render(conn, "discount.html", changeset: changeset)
  end

  def apply_discount(conn, %{"code" => discount_code_params}) do
    case CartContext.apply_discount(discount_code_params) do
      {:ok, cart} ->
        conn
        |> put_flash(:info, gettext("Discount applied successfully."))
        |> redirect(to: Routes.cart_path(conn, :show, cart))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:info, gettext("Discount not applied."))
    end
  end

  def delete(conn, %{"id" => id}) do
    cart = CartContext.get_cart!(id)
    {:ok, _cart} = CartContext.delete_cart(cart)

    conn
    |> put_flash(:info, "Cart deleted successfully.")
    |> redirect(to: Routes.cart_path(conn, :index))
  end

  def add_cart(conn, %{"id" => product_id}) do
    with %User{id: user_id} <- conn.private.guardian_default_resource,
         # fetch or create cart using user_id
         {:ok, cart} <- CartContext.get_or_create_cart(user_id),
         # adjust products_carts table with product id and cart_id
         {:ok, product_cart} <-
           CartContext.create_product_cart(%{cart_id: cart.id, product_id: product_id}),
         # [{product_cart{product: %{product}}}]
         products_carts <- CartContext.list_product_cart(cart.id),
         {:ok, cart} <- CartContext.update_cart(cart, cart_params(products_carts)) do
      products = fetch_products(products_carts)
      render(conn, "show.html", cart: cart, products: products)
    end
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
  
  defp cart_params([]) do
    %{number_of_products: 0, total_price: 0}
  end

  # return total items + price
  defp cart_params(products_carts) do
    number_of_products = Enum.count(products_carts)

    prices =
      Enum.map(products_carts, fn product_cart ->
        product = product_cart.product
        product.price
      end)
    IO.puts "++++++++++++++++++++++++++++++++++++++++++++++++++++"
    IO.inspect prices
    total_price =
      Enum.reduce(prices, fn price, acc ->
        price + acc
      end)

    %{number_of_products: number_of_products, total_price: total_price}
  end

  def delete_product(conn, %{"id" => id}) do
    user =  conn.private.guardian_default_resource
    {:ok, cart} = CartContext.get_or_create_cart(user.id)
    CartContext.delete_cart_product(id, cart.id)
    products_carts = CartContext.list_product_cart(cart.id)
    CartContext.update_cart(cart, cart_params(products_carts))
    conn
    |> put_flash(:info, gettext("Product deleted successfully."))
    |> redirect(to: Routes.cart_path(conn, :index))
  end

end
