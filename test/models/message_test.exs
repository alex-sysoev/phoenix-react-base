defmodule ReactChat.MessageTest do
  use ReactChat.ModelCase

  alias ReactChat.Message

  @valid_attrs %{content: "some content", conversation_id: 42, user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Message.changeset(%Message{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Message.changeset(%Message{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "validates presence of conversation_id" do
    attrs = Map.put(@valid_attrs, :conversation_id, nil)
    assert { :conversation_id, "can't be blank" } in errors_on(%Message{}, attrs)
  end

  test "validates presence of user_id" do
    attrs = Map.put(@valid_attrs, :user_id, nil)
    assert { :user_id, "can't be blank" } in errors_on(%Message{}, attrs)
  end
end
