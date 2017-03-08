defmodule ReactChat.RoleTest do
  use ReactChat.ModelCase

  alias ReactChat.Role

  @valid_attrs %{name: "guest"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Role.changeset(%Role{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Role.changeset(%Role{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "validates presence of name" do
    attrs = Map.put(@valid_attrs, :name, nil)
    assert { :name, "can't be blank" } in errors_on(%Role{}, attrs)
  end
end
