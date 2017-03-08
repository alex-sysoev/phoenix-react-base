defmodule ReactChat.RegistrationControllerTest do
	use ReactChat.ConnCase

	alias ReactChat.Repo
	alias ReactChat.User

	setup do
		insert_role()
		:ok
	end

	@valid_attrs 	 %{ email: "a@b.com", first_name: "A", last_name: "B", password: "megaSecret" }
	@invalid_attrs %{ email: "ab.com", first_name: "" }

	test "registers new user and logs it in", %{conn: conn} do
		conn = post(conn, api_registration_path(conn, :create, %{user: @valid_attrs}))
		user = Repo.preload(Repo.get_by(User, email: "a@b.com"), :roles)

		assert json_response(conn, 200)
		assert Guardian.Plug.current_resource(conn).email == @valid_attrs.email
		assert Enum.at(user.roles, 0).name == "guest"
	end 

	test "fails to register user with wrong params", %{conn: conn} do
		conn = post(conn, api_registration_path(conn, :create, %{user: @invalid_attrs}))

		assert json_response(conn, 422)
		assert json_response(conn, 422)["errors"] != nil
	end

end