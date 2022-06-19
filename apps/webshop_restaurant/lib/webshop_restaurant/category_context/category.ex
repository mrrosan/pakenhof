defmodule WebshopRestaurant.CategoryContext.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias WebshopRestaurant.ProductContext.Product


  schema "categories" do
    field :description, :string
    field :name, :string
    has_many :products, Product, on_delete: :delete_all
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
