defmodule ReactChat.Api.ErrorHandler do
	@moduledoc """
	This module handles different errors under Api namespace.
	"""
	use ReactChat.Web, :controller

	alias ReactChat.Api.ErrorsView

	@doc """
	Handles user authentication failure from Guardian Plug.
	"""
	def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render(ErrorsView, "error.json", message: "Authentication failed")
  end

	def handle_unauthorized(conn) do
	  conn
	  |> put_status(403)
	  |> render(ErrorsView, "error.json", message: "You can't access that page!")
	  |> halt
	end

end