defmodule ReactChat.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "conversations:*", ReactChat.ConversationChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  def connect(%{"token" => token}, socket) do
    case Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        case ReactChat.GuardianSerializer.from_token(claims["sub"]) do
          {:ok, user}       -> {:ok, assign(socket, :current_user, user) }
          {:error, _reason} -> :error
        end
      {:error, _reason} -> :error
    end
  end

  def connect(_params, _socket) do
    :error
  end

  def id(socket), do: "users_socket:#{socket.assigns.current_user.id}"
end
