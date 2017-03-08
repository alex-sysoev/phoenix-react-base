defmodule ReactChat.UserConversationTest do
  use ReactChat.ModelCase

  alias ReactChat.UserConversation

  @valid_attrs %{ user_id: 1, conversation_id: 1 }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserConversation.changeset(%UserConversation{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserConversation.changeset(%UserConversation{}, @invalid_attrs)
    refute changeset.valid?
  end
end
