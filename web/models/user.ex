defmodule ReactChat.User do
  use ReactChat.Web, :model

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_digest, :string

    many_to_many :conversations, ReactChat.Conversation, join_through: "user_conversations"
    many_to_many :roles, ReactChat.Role, join_through: "user_roles", on_delete: :delete_all

    timestamps()
  end

  def is_admin?(user) do
    ReactChat.Repo.preload(user, :roles).roles
    |> Enum.map(fn role -> role.name end)
    |> Enum.member?("admin")
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:first_name, :last_name, :email])
    |> validate_required([:first_name, :last_name, :email])
    |> unique_constraint(:email)
  end

  @doc """
  Changeset that is used for user update and does not
  validate presence of password but if present hashes it.
  """
  def update_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_length(:password, min: 8, max: 100)
    |> hash_password
  end

  @doc """
  Is used for user creation. Validates presence of password and
  hashes it.
  """
  def registration_changeset(struct, params \\ %{}) do
    struct
    |> update_changeset(params)
    |> validate_required(:password)
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{ valid?: true, changes: %{ password: password } } ->
        put_change(changeset, :password_digest, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
