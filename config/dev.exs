use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :react_chat, ReactChat.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/webpack/bin/webpack.js", "--watch-stdin", "--colors"]]

# Watch static and templates for browser reloading.
config :react_chat, ReactChat.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :react_chat, ReactChat.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASSWORD"),
  database: "react_chat_dev",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# config :react_chat, ReactChat.Repo,
#   adapter: Ecto.Adapters.Postgres,
#   username: "alexander",
#   password: "ego7idsql",
#   database: "react_chat_dev",
#   hostname: "localhost",
#   pool: Ecto.Adapters.SQL.Sandbox
