defmodule ReactChat.RoleControllerTest do
	use ReactChat.ConnCase

	setup do
		insert_role(%{name: "guest"})
		insert_role(%{name: "admin"})
		:ok
	end

	test "returns all roles", %{conn: conn} do
		conn = get(conn, api_role_path(conn, :index))

		assert json_response(conn, 200)
		assert Enum.count(json_response(conn, 200)) == 2
	end

end