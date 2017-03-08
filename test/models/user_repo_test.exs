defmodule ReactChat.UserRepoTest do
	use ReactChat.ModelCase

	alias ReactChat.User

  @valid_attrs %{email: "a@b.com", first_name: "Person", last_name: "Personson", 
    password: "12341234"}

	test "validates uniqueness of email" do
		insert_user(%{email: @valid_attrs.email})
		changeset = User.changeset(%User{}, @valid_attrs)

		assert {:error, changeset} = Repo.insert(changeset)
		assert { :email, {"has already been taken", []} } in changeset.errors
	end
end