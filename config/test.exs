use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :react_chat, ReactChat.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pbkdf2_rounds, 1

# Configure your database
config :react_chat, ReactChat.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASSWORD"),
  database: "react_chat_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
