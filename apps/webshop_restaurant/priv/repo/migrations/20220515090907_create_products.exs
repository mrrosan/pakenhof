defmodule WebshopRestaurant.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string, null: false
      add :price, :float, null: false
      add :description, :string
      add :quantity, :integer, null: false
      add :category_id, references(:categories), null: false, on_delete: :delete_all

    end
    create index(:products, [:category_id])
  end
end
