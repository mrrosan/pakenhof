defmodule WebshopRestaurantWeb.Api.ProductController do
    use WebshopRestaurantWeb, :controller
  
    alias WebshopRestaurant.ProductContext
    alias WebshopRestaurant.ProductContext.Product
    alias WebshopRestaurant.CategoryContext.Category
    alias WebshopRestaurant.CategoryContext
  
    def index(conn, _params) do
      products = ProductContext.list_products()
      render(conn, "index.json", products: products)
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
            |> put_status(:created)
            |> put_resp_header("location", Routes.product_path(conn, :show, product))
            |> render("show.json", product: product)
  
        {:error, _cs} ->
            conn
            |> send_resp(400, "Something went wrong, sorry.")
      end
    end
  
    def show(conn, %{"id" => id}) do
      product = ProductContext.get_product!(id)
      render(conn, "show.json", product: product)
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
            render(conn, "show.json", product: product)

        {:error, _cs} ->
            conn
            |> send_resp(400, "Something went wrong, sorry. Adjust your parameters --> never give up.")
      end
    end
  
    def delete(conn, %{"id" => id}) do
        product = ProductContext.get_product!(id)
        case ProductContext.delete_product(product) do
        {:ok, _product} -> 
            send_resp(conn, :no_content, "")
        {:error, cs} ->   # If delete failed, notify the end user about the failure
            conn
            |> send_resp(400, "Something went wrong, sorry.")
        end
    end
  end
  