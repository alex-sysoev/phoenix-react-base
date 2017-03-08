defmodule ReactChat.Conversation do
  use ReactChat.Web, :model

  schema "conversations" do
    field :name, :string
    
    many_to_many :users,    ReactChat.User, join_through: "user_conversations"
    has_many     :messages, ReactChat.Message
    
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
