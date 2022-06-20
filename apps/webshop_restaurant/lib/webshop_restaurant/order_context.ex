defmodule WebshopRestaurant.OrderContext do
  @moduledoc """
  The OrderContext context.
  """

  import Ecto.Query, warn: false
  alias WebshopRestaurant.Repo

  alias WebshopRestaurant.OrderContext.Order

  def list_orders(user_id) do
    Order
    |> where([order], order.user_id == ^user_id) #[pc] alias OrderProduct
    |> Repo.all()

  end

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(Order)
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id), do: Repo.get!(Order, id) |> Repo.preload(:user)

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  def apply_discount(discount_code, order_id) do
    IO.puts discount_code
    IO.puts order_id
    if discount_code == "DISCOUNT30" do
      order = get_order!(order_id)
      attrs = %{}
      discount = order.total_price * 0.30;
      total_price = order.total_price - discount;


      attrs = Map.put(attrs, :total_price, total_price)

      order
      |> Order.changeset(attrs)
      |> Repo.update()
    else
      {:error, %Order{}}
    end
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{data: %Order{}}

  """
  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
  end

  alias WebshopRestaurant.OrderContext.OrderProduct

  def create_order_product(attrs \\ %{}) do
    %OrderProduct{}
    |> OrderProduct.changeset(attrs)
    |> Repo.insert()
  end

  def list_order_product(order_id) do
    OrderProduct
    |> where([pc], pc.order_id == ^order_id)
    |> Repo.all()
    |> Repo.preload([:product])

  end

  def delete_order_product(product_id, order_id) do
    [first | _rest] = OrderProduct
    |> where([pc], pc.order_id == ^order_id)
    |> where([pc], pc.product_id == ^product_id)
    |> Repo.all()
    Repo.delete(first)

  end

end
