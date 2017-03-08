defmodule ReactChat.ConversationTest do
  use ReactChat.ModelCase

  alias ReactChat.Conversation

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Conversation.changeset(%Conversation{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Conversation.changeset(%Conversation{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "validates presence of name" do
    attrs = Map.put(@valid_attrs, :name, nil)
    assert { :name, "can't be blank" } in errors_on(%Conversation{}, attrs)
  end
end
