defmodule ReactChat.TestHelpers do
	use 	ReactChat.Web, :controller
	alias ReactChat.Repo
	alias ReactChat.Role
	alias ReactChat.UserRole

	def insert_user(attrs \\ %{})
	def insert_user(%{role: role_name} = attrs) do
		user = insert_user(Map.delete(attrs,:role))
		role = insert_role(%{name: role_name})
		Repo.insert!(%UserRole{ user_id: user.id, role_id: role.id })
		user
	end

	def insert_user(attrs) do
		changes = Map.merge(%{
			first_name: "Some",
			last_name: 	"One",
			email:			"some-#{Base.encode16(:crypto.strong_rand_bytes(8))}@one.com",
			password:		"megaSecret"
		}, attrs)

		%ReactChat.User{}
		|> ReactChat.User.registration_changeset(changes)
		|> Repo.insert!()
	end

	def insert_admin(attrs \\ %{}) do
		attrs = Map.merge(attrs, %{role: "admin"})
		insert_user(attrs)
	end

	def insert_role(attrs \\ %{}) do
		changes = Map.merge(%{
			name: "guest"
		}, attrs)

		case Repo.get_by(Role, name: changes.name) do
			nil ->
				%Role{}
				|> Role.changeset(changes)
				|> Repo.insert!
			role -> role
		end
	end

	def insert_conversation(attrs \\ %{}) do
		changes = Map.merge(%{
			name: "Conversation-#{Base.encode16(:crypto.strong_rand_bytes(8))}"
		}, attrs)

		%ReactChat.Conversation{}
		|> ReactChat.Conversation.changeset(changes)
		|> Repo.insert!()
	end

	def api_sign_in(conn, user) do
    new_conn = Guardian.Plug.api_sign_in(conn, user)
    token 	 = Guardian.Plug.current_token(new_conn)
    
    put_req_header(new_conn, "authorization", "Bearer #{token}")
    new_conn
	end
end