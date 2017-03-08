defmodule ReactChat.RoleRepoTest do
	use ReactChat.ModelCase

	alias ReactChat.Role

  @valid_attrs %{ name: "guest" }

	test "validates uniqueness of name" do
		insert_role(%{name: @valid_attrs.name})
		changeset = Role.changeset(%Role{}, @valid_attrs)

		assert {:error, changeset} = Repo.insert(changeset)
		assert { :name, {"has already been taken", []} } in changeset.errors
	end
end