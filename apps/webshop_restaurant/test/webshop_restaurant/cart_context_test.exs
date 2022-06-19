defmodule WebshopRestaurant.CartContextTest do
  use WebshopRestaurant.DataCase

  alias WebshopRestaurant.CartContext

  describe "carts" do
    alias WebshopRestaurant.CartContext.Cart

    @valid_attrs %{number_of_products: 42, total_price: 120.5}
    @update_attrs %{number_of_products: 43, total_price: 456.7}
    @invalid_attrs %{number_of_products: nil, total_price: nil}

    def cart_fixture(attrs \\ %{}) do
      {:ok, cart} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CartContext.create_cart()

      cart
    end

    test "list_carts/0 returns all carts" do
      cart = cart_fixture()
      assert CartContext.list_carts() == [cart]
    end

    test "get_cart!/1 returns the cart with given id" do
      cart = cart_fixture()
      assert CartContext.get_cart!(cart.id) == cart
    end

    test "create_cart/1 with valid data creates a cart" do
      assert {:ok, %Cart{} = cart} = CartContext.create_cart(@valid_attrs)
      assert cart.number_of_products == 42
      assert cart.total_price == 120.5
    end

    test "create_cart/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CartContext.create_cart(@invalid_attrs)
    end

    test "update_cart/2 with valid data updates the cart" do
      cart = cart_fixture()
      assert {:ok, %Cart{} = cart} = CartContext.update_cart(cart, @update_attrs)
      assert cart.number_of_products == 43
      assert cart.total_price == 456.7
    end

    test "update_cart/2 with invalid data returns error changeset" do
      cart = cart_fixture()
      assert {:error, %Ecto.Changeset{}} = CartContext.update_cart(cart, @invalid_attrs)
      assert cart == CartContext.get_cart!(cart.id)
    end

    test "delete_cart/1 deletes the cart" do
      cart = cart_fixture()
      assert {:ok, %Cart{}} = CartContext.delete_cart(cart)
      assert_raise Ecto.NoResultsError, fn -> CartContext.get_cart!(cart.id) end
    end

    test "change_cart/1 returns a cart changeset" do
      cart = cart_fixture()
      assert %Ecto.Changeset{} = CartContext.change_cart(cart)
    end
  end
end
