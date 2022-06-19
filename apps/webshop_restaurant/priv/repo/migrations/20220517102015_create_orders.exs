defmodule WebshopRestaurant.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :total_price, :float
      add :user_id, references(:users), null: false

      timestamps()
    end

  end
end
