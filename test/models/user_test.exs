defmodule ReactChat.UserTest do
  use ReactChat.ModelCase, async: true

  alias ReactChat.User

  @valid_attrs %{email: "a@b.com", first_name: "Person", last_name: "Personson", 
    password: "12341234"}
  
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "validates presence of arguments" do
    Enum.each([:email, :first_name, :last_name],
      fn attr ->
        attrs = Map.put(@valid_attrs, attr, nil)
        assert { attr, "can't be blank" } in errors_on(%User{}, attrs)
      end
    )
  end

  test "validates password length with update_changeset" do
    attrs = Map.put(@valid_attrs, :password, "1234")
    changeset = User.update_changeset(%User{}, attrs)
    assert { :password, {"should be at least %{count} character(s)", 
      [count: 8, validation: :length, min: 8]} } in changeset.errors
  end

  test "hashes password with update_changeset" do
    changeset = User.update_changeset(%User{}, @valid_attrs)
    %{ password: password, password_digest: password_digest } = changeset.changes

    assert changeset.valid?
    assert password_digest
    assert Comeonin.Bcrypt.checkpw(password, password_digest)
  end

  test "validates password presence with registration_changeset" do
    attrs = Map.put(@valid_attrs, :password, nil)
    changeset = User.registration_changeset(%User{}, attrs)
    assert { :password, {"can't be blank", [validation: :required]} } in changeset.errors
  end

end
