use Mix.Config

config :firmware_db, FirmwareDb.Repo,
  adapter: Sqlite.Ecto2,
  database: "/root/#{Mix.env}.sqlite3"

config :firmware_db, ecto_repos: [FirmwareDb.Repo]

import_config "config_network.exs"
