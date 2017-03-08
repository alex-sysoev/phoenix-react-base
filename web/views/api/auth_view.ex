defmodule ReactChat.Api.AuthView do
	use ReactChat.Web, :view

	def render("unauthorized.json", _params) do
		%{ error: "authentication failed" }
	end

	def render("show.json", %{user: user, token: token}) do
		%{
			user: render_one(user, ReactChat.Api.UserView, "user.json"),
			token: token
		}
	end

	def render("logout.json", _params) do
		%{ success: true, message: "logged out" }
	end
end