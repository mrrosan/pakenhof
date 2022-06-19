defmodule WebshopRestaurant.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias WebshopRestaurant.CartContext.Cart
  alias WebshopRestaurant.OrderContext.Order
  alias WebshopRestaurant.AuthToken
  @acceptable_roles ["Admin", "User"]
  

  schema "users" do
    field :address, :string
    field :city, :string
    field :email, :string
    field :firstname, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :house_number, :integer
    field :lastname, :string
    field :postal_code, :string
    field :role, :string, default: "User"

    has_one :cart, Cart
    has_many :orders, Order
    has_many :auth_tokens, AuthToken


  end

  def get_acceptable_roles, do: @acceptable_roles

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:firstname, :lastname, :email, :password, :role, :address, :house_number, :city, :postal_code])
    |> validate_required([:firstname, :lastname, :email, :password, :role, :address, :house_number, :city, :postal_code])
    #|> validate_inclusion(:role, @acceptable_roles)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, hashed_password: Pbkdf2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
