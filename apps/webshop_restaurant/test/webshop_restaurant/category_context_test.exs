defmodule WebshopRestaurant.CategoryContextTest do
  use WebshopRestaurant.DataCase

  alias WebshopRestaurant.CategoryContext

  describe "categories" do
    alias WebshopRestaurant.CategoryContext.Category

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CategoryContext.create_category()

      category
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert CategoryContext.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert CategoryContext.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = CategoryContext.create_category(@valid_attrs)
      assert category.description == "some description"
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CategoryContext.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, %Category{} = category} = CategoryContext.update_category(category, @update_attrs)
      assert category.description == "some updated description"
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = CategoryContext.update_category(category, @invalid_attrs)
      assert category == CategoryContext.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = CategoryContext.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> CategoryContext.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = CategoryContext.change_category(category)
    end
  end
end
