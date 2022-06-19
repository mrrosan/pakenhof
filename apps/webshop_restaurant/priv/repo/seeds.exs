# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     WebshopRestaurant.Repo.insert!(%WebshopRestaurant.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
{:ok, _cs} =
  WebshopRestaurant.UserContext.create_user(%{"password" => "t", "role" => "Admin", "email" => "test@test.com", "firstname" => "Roshan", "lastname" => "Shrestha", "address" => "Aarschotsesteenweg", "house_number" => 15, "city" => "Leuven", "postal_code" => "3000"})

{:ok, _cs} =
  WebshopRestaurant.UserContext.create_user(%{"password" => "t", "role" => "User", "email" => "test@test.be", "firstname" => "Lina", "lastname" => "Coenraets", "address" => "Kwikstraat", "house_number" => 16, "city" => "Kortenberg", "postal_code" => "3078"})

{:ok, _cs} =
  WebshopRestaurant.CategoryContext.create_category(%{"name" => "Main Dish", "description" => "The main course is usually the biggest dish on a menu. The main ingredient is often meat or fish."})

{:ok, _cs} =
  WebshopRestaurant.CategoryContext.create_category(%{"name" => "Appetizer", "description" => "Homemade food and drink that stimulates the appetite."})

{:ok, _cs} =
  WebshopRestaurant.CategoryContext.create_category(%{"name" => "Dessert", "description" => "You scream, I scream, We all scream for an ice-cream :)"})

{:ok, _cs} =
  WebshopRestaurant.ProductContext.create_product(%{"name" => "Irish Steak", "description" => "All meat and fish dishes are served with fries | croquettes | mash potato.", "price" => 23.50, "quantity" => 7, "category_id" => 1})
 
{:ok, _cs} =
  WebshopRestaurant.ProductContext.create_product(%{"name" => "Spaghetti Carbonara", "description" => "All pasta dishes are served with bread.", "price" => 16.50, "quantity" => 10, "category_id" => 1})

{:ok, _cs} =
  WebshopRestaurant.ProductContext.create_product(%{"name" => "Toast Smoked Salmon", "description" => "Served with fresh garden spices.", "price" => 13.50, "quantity" => 7, "category_id" => 2})

{:ok, _cs} =
  WebshopRestaurant.ProductContext.create_product(%{"name" => "Toast cheese and ham", "description" => "Served with fresh garden herbs.", "price" => 14.50, "quantity" => 1, "category_id" => 2})

{:ok, _cs} =
  WebshopRestaurant.ProductContext.create_product(%{"name" => "Dame Blanch", "description" => "Served with homemade hot choclate sauce", "price" => 8.50, "quantity" => 4, "category_id" => 3})

{:ok, _cs} =
  WebshopRestaurant.ProductContext.create_product(%{"name" => "Sabayon with vanille-ice", "description" => "Chef's special dessert", "price" => 8.50, "quantity" => 2, "category_id" => 3})

