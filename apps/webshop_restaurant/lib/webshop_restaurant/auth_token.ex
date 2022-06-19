defmodule WebshopRestaurant.AuthToken do
  use Ecto.Schema
  import Ecto.Changeset
  alias WebshopRestaurant.AuthToken
  alias WebshopRestaurant.UserContext.User
  schema "auth_tokens" do
    field :revoked, :boolean, default: false
    field :revoked_at, :utc_datetime
    field :token, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(%AuthToken{} = auth_token, attrs) do
    auth_token
    |> cast(attrs, [:token])
    |> validate_required([:token])
    |> unique_constraint(:token)
  end
end
