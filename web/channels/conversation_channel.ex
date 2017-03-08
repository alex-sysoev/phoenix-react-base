defmodule ReactChat.ConversationChannel do
	use ReactChat.Web, :channel

	alias ReactChat.Conversation
	alias ReactChat.Message

  def join("conversations:" <> id, _params, socket) do
    conversation = Repo.get!(Conversation, id)
    
    messages = 
    Message
    |> where([m], m.conversation_id == ^conversation.id)
 		|> preload(user: :roles)
 		|> Repo.all

    response = %{
      conversation: 
      	Phoenix.View.render_one(conversation, ReactChat.Api.ConversationView, "show.json"),
      messages: 
      	Phoenix.View.render_many(messages, ReactChat.Api.MessageView, "show.json")
    }

    {:ok, response, assign(socket, :conversation, conversation)}
  end

  def handle_in("new_message", params, socket) do
    changeset =
      socket.assigns.conversation
      |> build_assoc(:messages, user_id: socket.assigns.current_user.id)
      |> ReactChat.Message.changeset(params)

    case Repo.insert(changeset) do
      {:ok, message} ->
        broadcast_message(socket, message)
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, Phoenix.View.render(ReactChat.Api.ChangesetView, "errors.json", changeset: changeset)}, socket}
    end
	end

  def terminate(_reason, socket) do
    {:ok, socket}
	end

  defp broadcast_message(socket, message) do
    message = Repo.preload(message, user: :roles)
    rendered_message = Phoenix.View.render_one(message, ReactChat.Api.MessageView, "show.json")
    broadcast!(socket, "message_created", rendered_message)
	end
end