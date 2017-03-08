defmodule ReactChat.UserRoleRepoTest do
	use ReactChat.ModelCase

	alias ReactChat.UserRole

	test "validates uniqueness of user role pair" do
		role = insert_role()
		user = insert_user()
		Repo.insert!(%UserRole{ user_id: user.id, role_id: role.id })
		
		changeset = UserRole.changeset(%UserRole{}, %{ user_id: user.id, role_id: role.id })

		assert {:error, changeset} = Repo.insert(changeset)
		assert { :user_id_role_id, {"has already been taken", []} } in changeset.errors
	end
end