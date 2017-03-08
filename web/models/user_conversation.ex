defmodule ReactChat.UserConversation do
	use ReactChat.Web, :model

	schema "user_conversations" do
		belongs_to :user, ReactChat.User
		belongs_to :conversation, ReactChat.Conversation
	end

	def changeset(struct, params \\ %{}) do
		struct
		|> cast(params, [:user_id, :conversation_id])
		|> validate_required([:user_id, :conversation_id])
		|> unique_constraint(:user_id_conversation_id)
	end

end