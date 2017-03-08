defmodule ReactChat.UserControllerTest do
	use ReactChat.ConnCase
	alias ReactChat.Repo
	alias ReactChat.User

	setup %{conn: conn} = config do
		case config do
			%{login_as: email} -> 
				user = insert_user(%{email: email})
				conn = api_sign_in(conn, user)				
				{:ok, conn: conn, user: user}
			%{login_as_admin: email} ->
				user = insert_admin(%{email: email})
				conn = api_sign_in(conn, user)
				{:ok, conn: conn, user: user}
			_ -> :ok
		end
	end

	@valid_attrs 	 %{ email: "a@b.com", first_name: "A", last_name: "B", password: "megaSecret" }
	@invalid_attrs %{ email: "ab.com", first_name: "" }

	test "requires authentication on all actions", %{conn: conn} do
		Enum.each([
				get(conn, api_user_path(conn, :index)),
				get(conn, api_user_path(conn, :show, 1)),
				post(conn, api_user_path(conn, :create), %{user: %{}}),
				put(conn, api_user_path(conn, :update, 1), %{user: %{}}),
				delete(conn, api_user_path(conn, :delete, 1))
			], 
			fn conn ->
				assert json_response(conn, 401)
				assert conn.halted
			end
		)
	end

	@tag login_as: "user1@test.com"
	test "requires admin authorization on all actions", %{conn: conn} do
		Enum.each([
				get(conn, api_user_path(conn, :index)),
				get(conn, api_user_path(conn, :show, 1)),
				post(conn, api_user_path(conn, :create), %{user: %{}}),
				put(conn, api_user_path(conn, :update, 1), %{user: %{}}),
				delete(conn, api_user_path(conn, :delete, 1))
			],
			fn conn ->
				assert json_response(conn, 403)
				assert conn.halted
			end
		)
	end 

	defp user_count(query), do: Repo.one(from u in query, select: count(u.id))

	@tag login_as_admin: "user@test.com"
	test "returns all users from database", %{conn: conn} do
		insert_user(%{email: "user2@test.com"})
		conn = get(conn, api_user_path(conn, :index))

		assert json_response(conn, 200)
		assert length(json_response(conn, 200)["users"]) == 2
	end

	@tag login_as_admin: "user@test.com"
	test "returns user from database", %{conn: conn, user: user} do
		conn = get(conn, api_user_path(conn, :show, user.id))

		assert json_response(conn, 200)
		assert json_response(conn, 200)["id"] == user.id
	end

	@tag login_as_admin: "user@test.com"
	test "creates user", %{conn: conn} do
		conn = post(conn, api_user_path(conn, :create), %{user: @valid_attrs})

		assert json_response(conn, 200)
		assert json_response(conn, 200)["email"] == @valid_attrs.email
	end

	@tag login_as_admin: "user@test.com"
	test "fails to create user", %{conn: conn} do
		count = user_count(User)
		conn = post(conn, api_user_path(conn, :create), %{user: @invalid_attrs})

		assert json_response(conn, 422)
		assert json_response(conn, 422)["errors"] != nil
		assert user_count(User) == count
	end

	@tag login_as_admin: "user@test.com"
	test "updates user", %{conn: conn} do
		user = insert_user(%{email: "good@test.com"})
		conn = put(conn, api_user_path(conn, :update, user.id), %{user: %{email: "best@test.com"}})

		assert json_response(conn, 200)
		assert Repo.get!(User, user.id).email == "best@test.com"
	end

	@tag login_as_admin: "user@test.com"
	test "fails to update user", %{conn: conn} do
		user = insert_user(%{email: "good@test.com"})
		conn = put(conn, api_user_path(conn, :update, user.id), %{user: %{email: ""}})

		assert json_response(conn, 422)
		assert json_response(conn, 422)["errors"] != nil
		assert Repo.get!(User, user.id).email == "good@test.com"
	end

	@tag login_as_admin: "user@test.com"
	test "add roles to user on update", %{conn: conn} do
		guest = insert_role(%{name: "guest"})
		admin = insert_role(%{name: "admin"})
		user  = insert_user(%{email: "good@test.com", role: "guest"})
 
		conn  = put(conn, api_user_path(conn, :update, user.id), %{user: %{role_ids: [guest.id, admin.id]}})
		user  = Repo.get!(User, user.id)
		roles = Enum.map(Repo.preload(user, :roles).roles, fn r -> r.id end)

		assert json_response(conn, 200)
		assert Enum.member?(roles, admin.id)
		assert Enum.member?(roles, guest.id)
	end

	@tag login_as_admin: "user@test.com"
	test "removes user roles on update", %{conn: conn} do
		guest = insert_role(%{name: "guest"})
		user  = insert_user(%{email: "good@test.com", role: "guest"})
 
		conn  = put(conn, api_user_path(conn, :update, user.id), %{user: %{role_ids: []}})
		user  = Repo.get!(User, user.id)
		roles = Enum.map(Repo.preload(user, :roles).roles, fn r -> r.id end)

		assert json_response(conn, 200)
		assert !Enum.member?(roles, guest.id)
	end

	@tag login_as_admin: "user@test.com"
	test "deletes user", %{conn: conn} do
		user 	= insert_user(%{email: "good@test.com"})
		count = user_count(User)
		conn 	= delete(conn, api_user_path(conn, :delete, user.id))

		assert json_response(conn, 200)
		assert user_count(User) == count-1
	end

end