defmodule ReactChat.ConversationRepoTest do
	use ReactChat.ModelCase

	alias ReactChat.Conversation

  @valid_attrs %{ name: "Some Conversation" }

	test "validates uniqueness of name" do
		insert_conversation(%{name: @valid_attrs.name})
		changeset = Conversation.changeset(%Conversation{}, @valid_attrs)

		assert {:error, changeset} = Repo.insert(changeset)
		assert { :name, {"has already been taken", []} } in changeset.errors
	end
end