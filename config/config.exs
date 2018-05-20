# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config


config :upload,
  port: 8080,
  uploads_dir: "uploads",
  download_chunk_size: 5000

# General application configuration
#config :imageer,
#  ecto_repos: [Imageer.Repo]

# Configures the endpoint
#config :imageer, Imageer.Endpoint,
##https://github.com/phoenixframework/phoenix/blob/master/lib/phoenix/endpoint/cowboy_handler.ex
#    http: [dispatch: [
#      {:_, [
#          {"/upload", Imageer.UploadHandler , [
#
#          #   callback:
#          # &Imageer.Chunker.create/3,
#
#          # callback_args: [
#          # :id, :chunk_size, :callback)
#          # ]
#
#
#          ]} ,
#          # this needs to be disabled in production environment TODO
#          {"/phoenix/live_reload/socket/websocket", Phoenix.Endpoint.CowboyWebSocket,
#            {Phoenix.Transports.WebSocket,
#              {Imageer.Endpoint, Phoenix.LiveReloader.Socket, :websocket}}},
#          {:_, Plug.Adapters.Cowboy.Handler, {Imageer.Endpoint, []}}
#        ]}]],
#  url: [host: "localhost"],
#  secret_key_base: "pzRunDKjDtcDlStXUusRe+R8bvezm7zMxFjbgxJQkgzAkgYrSGNb9lIAJc3JKbv9",
#  render_errors: [view: Imageer.ErrorView, accepts: ~w(html json)],
#  pubsub: [name: Imageer.PubSub,
#           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
