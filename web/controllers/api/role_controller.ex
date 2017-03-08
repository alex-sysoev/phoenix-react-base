defmodule ReactChat.Api.RoleController do
	use ReactChat.Web, :controller

	alias ReactChat.Role

	def index(conn, _params) do
		roles = Repo.all(Role)
		render(conn, "index.json", roles: roles)
	end

end