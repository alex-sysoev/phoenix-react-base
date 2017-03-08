defmodule ReactChat.Api.ConversationController do
	use ReactChat.Web, :controller

	plug Guardian.Plug.EnsureAuthenticated, %{handler: ReactChat.Api.ErrorHandler}

	alias ReactChat.Conversation

	def show(conn, %{"id" => id}) do
		conversation = Repo.get!(Conversation, id)
		conversation = Repo.preload(conversation, :messages)
		render(conn, "show.json", conversation: conversation)
	end

end