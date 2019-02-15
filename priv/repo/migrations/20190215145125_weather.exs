defmodule FirmwareDb.Repo.Migrations.Weather do
  use Ecto.Migration

  def change do
    create table(:weather) do
      add :city,    :string
      add :temp_lo, :integer
      add :temp_hi, :integer
      add :prcp,    :float
    end
  end
end
