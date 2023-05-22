# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :swap_challenge_github, SwapChallengeGithubWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ID1tQd02tWkYBWSnNk3/95kZTpNW7FXjfjXzX31M+mCpPBjnesyc73umGuEzg9wt",
  render_errors: [view: SwapChallengeGithubWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: SwapChallengeGithub.PubSub,
  live_view: [signing_salt: "7JGdt+gr"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
