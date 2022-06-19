defmodule WebshopRestaurantWeb.CartControllerTest do
  use WebshopRestaurantWeb.ConnCase

  alias WebshopRestaurant.CartContext

  @create_attrs %{number_of_products: 42, total_price: 120.5}
  @update_attrs %{number_of_products: 43, total_price: 456.7}
  @invalid_attrs %{number_of_products: nil, total_price: nil}

  def fixture(:cart) do
    {:ok, cart} = CartContext.create_cart(@create_attrs)
    cart
  end

  describe "index" do
    test "lists all carts", %{conn: conn} do
      conn = get(conn, Routes.cart_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Carts"
    end
  end

  describe "new cart" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.cart_path(conn, :new))
      assert html_response(conn, 200) =~ "New Cart"
    end
  end

  describe "create cart" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.cart_path(conn, :create), cart: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.cart_path(conn, :show, id)

      conn = get(conn, Routes.cart_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Cart"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.cart_path(conn, :create), cart: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Cart"
    end
  end

  describe "edit cart" do
    setup [:create_cart]

    test "renders form for editing chosen cart", %{conn: conn, cart: cart} do
      conn = get(conn, Routes.cart_path(conn, :edit, cart))
      assert html_response(conn, 200) =~ "Edit Cart"
    end
  end

  describe "update cart" do
    setup [:create_cart]

    test "redirects when data is valid", %{conn: conn, cart: cart} do
      conn = put(conn, Routes.cart_path(conn, :update, cart), cart: @update_attrs)
      assert redirected_to(conn) == Routes.cart_path(conn, :show, cart)

      conn = get(conn, Routes.cart_path(conn, :show, cart))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, cart: cart} do
      conn = put(conn, Routes.cart_path(conn, :update, cart), cart: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Cart"
    end
  end

  describe "delete cart" do
    setup [:create_cart]

    test "deletes chosen cart", %{conn: conn, cart: cart} do
      conn = delete(conn, Routes.cart_path(conn, :delete, cart))
      assert redirected_to(conn) == Routes.cart_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.cart_path(conn, :show, cart))
      end
    end
  end

  defp create_cart(_) do
    cart = fixture(:cart)
    %{cart: cart}
  end
end
