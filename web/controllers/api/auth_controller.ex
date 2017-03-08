defmodule ReactChat.Api.AuthController do
	use ReactChat.Web, :controller
	
	import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

	plug Guardian.Plug.EnsureAuthenticated, 
		%{handler: ReactChat.Api.ErrorHandler} when not action in [:create]

	alias ReactChat.User

	@doc """
	Login request handle function that returns json with user & token
	in case of success and unauthorized error in case of failure 
	"""
	def create(conn, %{"email" => email, "password" => password}) do
		user = Repo.get_by(User, email: email)

		result = cond do
			user && checkpw(password, user.password_digest) ->
				{:ok, ReactChat.Api.Auth.login(conn, user)}
			user ->
				{:error, :unauthorized, conn}
			true ->
				dummy_checkpw()
				{:error, :not_found, conn}
		end

		case result do
			{:ok, conn} ->
				token = Guardian.Plug.current_token(conn)
				user  = Repo.preload(user, :roles)

				conn
				|> render("show.json", user: user, token: token)
			{:error, _reason, conn} ->
				conn
				|> put_status(:unauthorized)
				|> render("unauthorized.json", %{})
		end
	end

	@doc """
	Function that refreshes user session and returns json with
	current user and new token or 401 when fails.
	"""
	def show(conn, _params) do
    user = conn
    	|> Guardian.Plug.current_resource()
    	|> Repo.preload(:roles)

    token = Guardian.Plug.current_token(conn)
    {:ok, claims} = Guardian.Plug.claims(conn)

    case Guardian.refresh!(token, claims, %{ttl: {30, :days}}) do
      {:ok, new_token, _new_claims} ->
        conn
        |> put_status(:ok)
        |> render("show.json", user: user, token: new_token)
      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> render("unauthorized.json", %{})
    end
	end

	@doc """
	Logout function that revokes user token.
	"""
	def delete(conn, _params) do
  	token 				= Guardian.Plug.current_token(conn)
  	{:ok, claims} = Guardian.Plug.claims(conn)
  	
  	Guardian.revoke!(token, claims)
  	render(conn, "logout.json", %{})
	end

end