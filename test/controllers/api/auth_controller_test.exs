defmodule ReactChat.AuthControllerTest do
	use ReactChat.ConnCase

	setup do
		user = insert_user(%{email: "a@b.com", password: "megaSecret"})
		{:ok, user: user}
	end

	test "requires authentication on all actions except :create", %{conn: conn} do
		Enum.each([
			get(conn, api_auth_path(conn, :show, "this")),
			delete(conn, api_auth_path(conn, :delete, "this"))
		], 
		fn conn ->
			assert json_response(conn, 401)
			assert conn.halted
		end)
	end

	test "logs in user and returns token", %{conn: conn, user: user} do
		conn = post(conn, api_auth_path(conn, :create, %{email: user.email, password: user.password}))
	
		assert json_response(conn, 200)
		assert Guardian.Plug.current_resource(conn).id == user.id
		assert json_response(conn, 200)["token"] != nil
	end

	test "fails to log in with wrong credentials", %{conn: conn} do
		conn = post(conn, api_auth_path(conn, :create, %{email: "b@c.com", password: "bla"}))

		assert json_response(conn, 401)
	end

	test "fails to refresh session", %{conn: conn} do
		conn = get(conn, api_auth_path(conn, :show, "this"))

		assert json_response(conn, 401)
	end

	test "refreshes session and return new token", %{conn: conn, user: user} do
		conn_ = post(conn, api_auth_path(conn, :create, %{email: user.email, password: user.password}))
		token = json_response(conn_, 200)["token"]
		conn  = put_req_header(conn, "authorization", "Bearer #{token}")

		conn  = get(conn, api_auth_path(conn, :show, "this"))

		assert json_response(conn, 200)
		assert json_response(conn, 200)["token"] != token
	end

	test "logs user out", %{conn: conn, user: user} do
		conn = conn
			|> api_sign_in(user)
			|> delete(api_auth_path(conn, :delete, "this"))

		assert json_response(conn, 200)
	end
end