defmodule ReactChat.Api.MessageView do
	use ReactChat.Web, :view

	def render("show.json", %{message: message}) do
		%{
			id: 				 message.id,
			content: 		 message.content,
			user: 			 render_one(message.user, ReactChat.Api.UserView, "user.json"),
			inserted_at: message.inserted_at
		}
	end
end