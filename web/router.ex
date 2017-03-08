defmodule ReactChat.Router do
  use ReactChat.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug ReactChat.Api.Plug.CurrentUser
  end

  scope "/api", ReactChat.Api, as: :api do
    pipe_through :api

    resources "/users",         UserController
    resources "/sessions",      AuthController
    resources "/registrations", RegistrationController, only: [:create]
    resources "/conversations", ConversationController
    resources "/roles",         RoleController,         only: [:index]
  end

  scope "/", ReactChat do
    pipe_through :browser # Use the default browser stack

    get "/*path", PageController, :index
  end
end
