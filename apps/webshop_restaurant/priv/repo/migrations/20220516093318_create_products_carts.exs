defmodule WebshopRestaurant.Repo.Migrations.CreateProductsCarts do
  use Ecto.Migration

  def change do
    create table(:products_carts) do
      add :product_id, references(:products)
      add :cart_id, references(:carts)
    end

    create index(:products_carts, [:product_id, :cart_id])
  end
end
