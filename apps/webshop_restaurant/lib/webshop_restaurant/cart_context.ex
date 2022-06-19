defmodule WebshopRestaurant.CartContext do
  @moduledoc """
  The CartContext context.
  """

  import Ecto.Query, warn: false
  alias WebshopRestaurant.Repo

  alias WebshopRestaurant.CartContext.Cart

  @doc """
  Returns the list of carts.

  ## Examples

      iex> list_carts()
      [%Cart{}, ...]

  """
  def list_carts do
    Repo.all(Cart)
  end

  @doc """
  Gets a single cart.

  Raises `Ecto.NoResultsError` if the Cart does not exist.

  ## Examples

      iex> get_cart!(123)
      %Cart{}

      iex> get_cart!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cart!(id), do: Repo.get!(Cart, id)

  
  def get_or_create_cart(user_id) do
    case Repo.get_by(Cart, user_id: user_id) do #returns cart if user has one
      nil -> create_cart(%{user_id: user_id})
      cart -> {:ok, cart}
    end
  end

  @doc """
  Creates a cart.

  ## Examples

      iex> create_cart(%{field: value})
      {:ok, %Cart{}}

      iex> create_cart(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cart(attrs \\ %{}) do
    %Cart{}
    |> Cart.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a cart.

  ## Examples

      iex> update_cart(cart, %{field: new_value})
      {:ok, %Cart{}}

      iex> update_cart(cart, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cart(%Cart{} = cart, attrs) do
    cart
    |> Cart.changeset(attrs)
    |> Repo.update()
  end

  def apply_discount(%Cart{} = cart, attrs) do

    IO.inspect attrs
    cart
    |> Cart.changeset_discount_code(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a cart.

  ## Examples

      iex> delete_cart(cart)
      {:ok, %Cart{}}

      iex> delete_cart(cart)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cart(%Cart{} = cart) do
    Repo.delete(cart)
  end


  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cart changes.

  ## Examples

      iex> change_cart(cart)
      %Ecto.Changeset{data: %Cart{}}

  """
  def change_cart(%Cart{} = cart, attrs \\ %{}) do
    Cart.changeset(cart, attrs)
  end

  alias WebshopRestaurant.ProductCartContext.ProductCart
  def create_product_cart(attrs \\ %{}) do
    %ProductCart{}
    |> ProductCart.changeset(attrs)
    |> Repo.insert()
  end

  def list_product_cart(cart_id) do
    ProductCart
    |> where([pc], pc.cart_id == ^cart_id)
    |> Repo.all()
    |> Repo.preload([:product])

  end

  def delete_cart_product(product_id, cart_id) do
    [first | _rest] = ProductCart
    |> where([pc], pc.cart_id == ^cart_id)
    |> where([pc], pc.product_id == ^product_id)
    |> Repo.all()
    Repo.delete(first)

  end

end

