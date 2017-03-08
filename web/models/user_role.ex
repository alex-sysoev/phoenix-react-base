defmodule ReactChat.UserRole do
  use ReactChat.Web, :model

  schema "user_roles" do
    belongs_to :user, ReactChat.User
    belongs_to :role, ReactChat.Role
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :role_id])
    |> validate_required([:user_id, :role_id])
    |> unique_constraint(:user_id_role_id)
  end
end
