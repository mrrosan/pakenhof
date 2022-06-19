defmodule WebshopRestaurant.Repo.Migrations.CreateOrdersProducts do
  use Ecto.Migration

  def change do
    create table(:orders_products) do
      add :product_id, references(:products)
      add :order_id, references(:orders)
    end

    create index(:orders_products, [:product_id, :order_id])
  end
end
