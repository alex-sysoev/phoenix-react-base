defmodule ReactChat.Api.ConversationView do
	use ReactChat.Web, :view

	def render("show.json", %{conversation: conversation}) do
		%{
			id: 	conversation.id,
			name: conversation.name
		}
	end
end