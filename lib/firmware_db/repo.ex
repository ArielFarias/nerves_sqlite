defmodule FirmwareDb.Repo do
  use Ecto.Repo, otp_app: :firmware_db, adapter: Sqlite.Ecto2
end