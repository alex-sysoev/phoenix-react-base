defmodule ReactChat.Api.RegistrationView do
	use ReactChat.Web, :view

	def render("create.json", %{user: user, token: token}) do
		%{
			user: render_one(user, ReactChat.Api.UserView, "user.json"),
			token: token
		}
	end

end