defmodule WebshopRestaurant.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :firstname, :string, null: false
      add :lastname, :string, null: false
      add :email, :string, null: false
      add :hashed_password, :string, null: false
      add :role, :string, null: false
      add :address, :string, null: false
      add :house_number, :integer, null: false
      add :city, :string, null: false
      add :postal_code, :string, null: false

    end

    create unique_index(:users, [:email])
  end
end
