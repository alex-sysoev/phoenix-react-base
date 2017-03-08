defmodule ReactChat.Api.Auth do
	use ReactChat.Web, :controller

	def login(conn, user) do
    conn_ 				= Guardian.Plug.api_sign_in(conn, user)
    token 	 			= Guardian.Plug.current_token(conn_)
    {:ok, claims} = Guardian.Plug.claims(conn_)
    expires 			= Map.get(claims, "exp")

    conn_
    |> put_resp_header("authorization", "Bearer #{token}")
    |> put_resp_header("x-expires", "#{expires}")
	end 

end