defmodule ReactChat.UserConversationRepoTest do
	use ReactChat.ModelCase

	alias ReactChat.UserConversation

	test "validates uniqueness of user role pair" do
		conv = insert_conversation()
		user = insert_user()
		Repo.insert!(%UserConversation{ user_id: user.id, conversation_id: conv.id })
		
		changeset = UserConversation.changeset(
			%UserConversation{}, 
			%{ user_id: user.id, conversation_id: conv.id }
		)

		assert {:error, changeset} = Repo.insert(changeset)
		assert { :user_id_conversation_id, {"has already been taken", []} } in changeset.errors
	end
end