defmodule ReactChat.CurrentUserTest do
	use ReactChat.ConnCase

	setup %{conn: conn} do
		user = insert_user(%{email: "a@b.com"})
		conn = 
			conn
			|> api_sign_in(user)
			|> bypass_through(ReactChat.Router, :api)
			|> get("/")

		{:ok, %{conn: conn}}
	end

	test "sets current_user to conn", %{conn: conn} do
		assert conn.assigns.current_user.email == "a@b.com"
	end
end