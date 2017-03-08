# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :react_chat,
  ecto_repos: [ReactChat.Repo]

# Configures the endpoint
config :react_chat, ReactChat.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yJR9fertzTi9QzhmaLnMpd6PrjUQMdUV9buoKFdRmwsehHGYtJvyS4s3fFwNcVNg",
  render_errors: [view: ReactChat.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ReactChat.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
 issuer: "ReactChat.#{Mix.env}",
 ttl: {30, :days},
 verify_issuer: true,
 serializer: ReactChat.GuardianSerializer,
 secret_key: to_string(Mix.env) <> "SuPerseCret_aBraCadabrA"

config :canary, 
	unauthorized_handler: {ReactChat.Api.ErrorHandler, :handle_unauthorized},
	repo: ReactChat.Repo

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
