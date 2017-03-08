require IEx

defmodule ReactChat.Api.UserController do
	use ReactChat.Web, :controller
	plug Guardian.Plug.EnsureAuthenticated, %{handler: ReactChat.Api.ErrorHandler}

	alias ReactChat.User
	alias ReactChat.UserRole
	alias ReactChat.Paginator

	plug :authorize_resource, model: User

	@doc """
	Returns all users from database
	"""
	def index(conn, params) do
		paginator = 
			User
			|> Paginator.new(Map.merge(params, %{preload: [:roles]}))

		render(conn, "index.json", paginator: paginator)
	end

	@doc """
	Return user from database. Could be used to return current user
	profile.
	"""
	def show(conn, %{"id" => id}) do
		user = User
			|> Repo.get!(id)
			|> Repo.preload(:roles)

		render(conn, "user.json", user: user)
	end

	@doc """
	Create new user using the registration changeset that
	validate presence of password and hashes it returning json 
	with user or with changeset errors. When is called without user
	param returns 422.
	"""
	def create(conn, %{"user" => user_params}) do
		changeset = User.registration_changeset(%User{}, user_params)

		case Repo.insert(changeset) do
			{:ok, user} -> 
				user = 
					user
					|> Repo.preload(:roles)
					|> handle_roles(user_params)

				conn
				|> render("user.json", user: user)
			{:error, changeset} ->
				conn
				|> put_status(:unprocessable_entity)
				|> render(ReactChat.Api.ChangesetView, "errors.json", changeset: changeset)
		end
	end

	def create(conn, _params) do
		conn
		|> put_status(:unprocessable_entity)
		|> render(ReactChat.Api.ErrorsView, "error.json", message: "Bad request")
	end

	@doc """
	Updates user using update changeset that does not validate
	presence of password but if presents hashes it.
	"""
	def update(conn, %{"id" => id, "user" => user_params}) do
		user = Repo.get!(User, id)
		changeset = User.update_changeset(user, user_params)

		case Repo.update(changeset) do
			{:ok, user} ->
				user = 
					user
					|> Repo.preload(:roles)
					|> handle_roles(user_params)

				conn
				|> render("user.json", user: user)
			{:error, changeset} ->
				conn
				|> put_status(:unprocessable_entity)
				|> render(ReactChat.Api.ChangesetView, "errors.json", changeset: changeset)
		end
	end

	@doc """
	Removes user from database.
	"""
	def delete(conn, %{"id" => id}) do
		user = Repo.get!(User, id)
		Repo.delete!(user)

		conn
		|> render("delete.json", %{})
	end

	def handle_roles(user, %{"role_ids" => role_ids}) do
		current_role_ids = Enum.map(Repo.preload(user, :roles).roles, fn r -> r.id end)

		for id <- role_ids do
			Repo.get_by(UserRole, %{user_id: user.id, role_id: id}) ||
				Repo.insert(%UserRole{ user_id: user.id, role_id: id })
		end

		for id <- current_role_ids do
			if !Enum.member?(role_ids, id) do
				UserRole
				|> Repo.get_by(%{user_id: user.id, role_id: id})
				|> Repo.delete!
			end
		end

		user
	end
	def handle_roles(user, _), do: user

end