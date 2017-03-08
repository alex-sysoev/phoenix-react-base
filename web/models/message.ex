defmodule ReactChat.Message do
  use ReactChat.Web, :model

  schema "messages" do
    field :content, :string
    
    belongs_to :conversation, ReactChat.Conversation
    belongs_to :user,         ReactChat.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content, :conversation_id, :user_id])
    |> validate_required([:content, :conversation_id, :user_id])
  end
end
