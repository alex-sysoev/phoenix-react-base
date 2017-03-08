defmodule ReactChat.Api.UserView do
	use ReactChat.Web, :view

	def render("index.json", %{paginator: paginator}) do
		%{
			users: render_many(paginator.entries, ReactChat.Api.UserView, "user.json"),
			page:  paginator.page_number,
			total_pages: paginator.total_pages
		}
	end

	def render("delete.json", _) do
		%{success: true}
	end

	def render("user.json", %{user: user}) do
		%{
			id: user.id,
			first_name: user.first_name,
			last_name: user.last_name,
			email: user.email,
			roles: Enum.map(user.roles, fn r -> %{id: r.id, name: r.name} end) 
		}
	end
end