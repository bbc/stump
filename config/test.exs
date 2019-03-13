use Mix.Config

config :event_logger, time_api: EventLogger.Time.MockTime

config :logger, :console,
  format: "$message\n",
  colors: [enabled: false]