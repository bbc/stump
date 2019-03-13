use Mix.Config

config :stump, time_api: Stump.Time.MockTime

config :logger, :console,
  format: "$message\n",
  colors: [enabled: false]