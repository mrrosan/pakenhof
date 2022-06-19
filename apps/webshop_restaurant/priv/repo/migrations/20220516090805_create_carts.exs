defmodule WebshopRestaurant.Repo.Migrations.CreateCarts do
  use Ecto.Migration

  def change do
    create table(:carts) do
      add :number_of_products, :integer
      add :total_price, :float
      add :discount_code, :boolean
      add :user_id, references(:users), null: false

      timestamps()
    end

  end
end
