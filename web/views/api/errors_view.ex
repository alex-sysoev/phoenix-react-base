defmodule ReactChat.Api.ErrorsView do
	use ReactChat.Web, :view

	def render("error.json", %{message: message}) do
		%{ error: message }
	end

end