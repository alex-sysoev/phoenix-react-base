defmodule ReactChat.ConversationControllerTest do
	use ReactChat.ConnCase

	setup %{conn: conn} = config do
		conv = insert_conversation()

		case config do
			%{login_as: email} -> 
				user = insert_user(%{email: email})
				conn = api_sign_in(conn, user)				
				{:ok, conn: conn, user: user, conv: conv}
			%{login_as_admin: email} ->
				user = insert_admin(%{email: email})
				conn = api_sign_in(conn, user)
				{:ok, conn: conn, user: user}
			_ -> :ok
		end
	end

	test "requires authentication on all actions", %{conn: conn} do
		Enum.each([
				get(conn, api_conversation_path(conn, :show, 1))
			], 
			fn conn ->
				assert json_response(conn, 401)
				assert conn.halted
			end
		)
	end

	@tag login_as: "user@test.com"
	test "returns conversation", %{conn: conn, conv: conv} do
		conn = get(conn, api_conversation_path(conn, :show, conv.id))

		assert json_response(conn, 200)
		assert json_response(conn, 200)["id"] == conv.id
	end

end