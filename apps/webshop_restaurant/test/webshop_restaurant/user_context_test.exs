defmodule WebshopRestaurant.UserContextTest do
  use WebshopRestaurant.DataCase

  alias WebshopRestaurant.UserContext

  describe "users" do
    alias WebshopRestaurant.UserContext.User

    @valid_attrs %{address: "some address", city: "some city", email: "some email", firstname: "some firstname", hashed_password: "some hashed_password", house_number: 42, lastname: "some lastname", postal_code: "some postal_code", role: "some role"}
    @update_attrs %{address: "some updated address", city: "some updated city", email: "some updated email", firstname: "some updated firstname", hashed_password: "some updated hashed_password", house_number: 43, lastname: "some updated lastname", postal_code: "some updated postal_code", role: "some updated role"}
    @invalid_attrs %{address: nil, city: nil, email: nil, firstname: nil, hashed_password: nil, house_number: nil, lastname: nil, postal_code: nil, role: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserContext.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert UserContext.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert UserContext.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = UserContext.create_user(@valid_attrs)
      assert user.address == "some address"
      assert user.city == "some city"
      assert user.email == "some email"
      assert user.firstname == "some firstname"
      assert user.hashed_password == "some hashed_password"
      assert user.house_number == 42
      assert user.lastname == "some lastname"
      assert user.postal_code == "some postal_code"
      assert user.role == "some role"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserContext.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = UserContext.update_user(user, @update_attrs)
      assert user.address == "some updated address"
      assert user.city == "some updated city"
      assert user.email == "some updated email"
      assert user.firstname == "some updated firstname"
      assert user.hashed_password == "some updated hashed_password"
      assert user.house_number == 43
      assert user.lastname == "some updated lastname"
      assert user.postal_code == "some updated postal_code"
      assert user.role == "some updated role"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = UserContext.update_user(user, @invalid_attrs)
      assert user == UserContext.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = UserContext.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> UserContext.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = UserContext.change_user(user)
    end
  end
end
