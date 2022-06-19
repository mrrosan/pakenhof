defmodule WebshopRestaurantWeb.ProductController do
  use WebshopRestaurantWeb, :controller

  alias WebshopRestaurant.ProductContext
  alias WebshopRestaurant.ProductContext.Product
  alias WebshopRestaurant.CategoryContext.Category
  alias WebshopRestaurant.CategoryContext

  def index(conn, _params) do
    products = ProductContext.list_products()
    render(conn, "index.html", products: products)
  end

  def new(conn, _params) do
    changeset = ProductContext.change_product(%Product{})
    categories = CategoryContext.list_categories()
    render(conn, "new.html", changeset: changeset, categories: categories)
  end

  def create(conn, %{"product" => product_params}) do
    case ProductContext.create_product(product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, gettext("Product created successfully."))
        |> redirect(to: Routes.product_path(conn, :show, product))

      {:error, %Ecto.Changeset{} = changeset} ->
        categories = CategoryContext.list_categories()
        render(conn, "new.html", changeset: changeset, categories: categories)
    end
  end

  def show(conn, %{"id" => id}) do
    product = ProductContext.get_product!(id)
    render(conn, "show.html", product: product)
  end

  def edit(conn, %{"id" => id}) do
    categories = CategoryContext.list_categories()
    product = ProductContext.get_product!(id)
    changeset = ProductContext.change_product(product)
    render(conn, "edit.html", product: product, changeset: changeset, categories: categories)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = ProductContext.get_product!(id)

    case ProductContext.update_product(product, product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, gettext("Product updated successfully."))
        |> redirect(to: Routes.product_path(conn, :show, product))

      {:error, %Ecto.Changeset{} = changeset} ->
        categories = CategoryContext.list_categories()
        render(conn, "edit.html", product: product, changeset: changeset, categories: categories)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = ProductContext.get_product!(id)
    IO.inspect product
    {:ok, _product} = ProductContext.delete_product(product)

    conn
    |> put_flash(:info, gettext("Product deleted successfully."))
    |> redirect(to: Routes.product_path(conn, :index))
  end
end
