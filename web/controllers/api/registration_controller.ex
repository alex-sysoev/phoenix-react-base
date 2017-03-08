defmodule ReactChat.Api.RegistrationController do
	use ReactChat.Web, :controller

	alias ReactChat.User
	alias ReactChat.Role
	alias ReactChat.UserRole

	@doc """
	Create new user using the registration changeset that
	validate presence of password and hashes it returning json 
	with user or with changeset errors.
	"""
	def create(conn, %{"user" => user_params}) do
		changeset = User.registration_changeset(%User{}, user_params)

		case Repo.insert(changeset) do
			{:ok, user} ->
				set_role(user.id)

				user  = Repo.preload(user, :roles)
				conn_ = ReactChat.Api.Auth.login(conn, user)
				token = Guardian.Plug.current_token(conn_)
				
				render(conn_, "create.json", user: user, token: token)
			{:error, changeset} ->
				conn
				|> put_status(:unprocessable_entity)
				|> render(ReactChat.Api.ChangesetView, "errors.json", changeset: changeset)
		end
	end

	defp set_role(user_id) do
		role  		= Repo.get_by(Role, name: "guest")
		changeset = UserRole.changeset(%UserRole{}, %{user_id: user_id, role_id: role.id})

		case Repo.insert(changeset) do
			{:ok, 	 _role} 		-> :ok
			{:error, changeset} -> {:error, changeset}
		end
	end
end