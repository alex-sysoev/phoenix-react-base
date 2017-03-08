defmodule ReactChat.Api.RoleView do
	use ReactChat.Web, :view

	def render("index.json", %{roles: roles}) do
		render_many(roles, ReactChat.Api.RoleView, "show.json")
	end

	def render("show.json", %{role: role}) do
		%{
			id: 	role.id,
			name:	role.name
		}
	end
end