defmodule WebshopRestaurant.OrderContextTest do
  use WebshopRestaurant.DataCase

  alias WebshopRestaurant.OrderContext

  describe "orders" do
    alias WebshopRestaurant.OrderContext.Order

    @valid_attrs %{total_price: 120.5}
    @update_attrs %{total_price: 456.7}
    @invalid_attrs %{total_price: nil}

    def order_fixture(attrs \\ %{}) do
      {:ok, order} =
        attrs
        |> Enum.into(@valid_attrs)
        |> OrderContext.create_order()

      order
    end

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert OrderContext.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert OrderContext.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      assert {:ok, %Order{} = order} = OrderContext.create_order(@valid_attrs)
      assert order.total_price == 120.5
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = OrderContext.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      assert {:ok, %Order{} = order} = OrderContext.update_order(order, @update_attrs)
      assert order.total_price == 456.7
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = OrderContext.update_order(order, @invalid_attrs)
      assert order == OrderContext.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = OrderContext.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> OrderContext.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = OrderContext.change_order(order)
    end
  end
end
