defmodule FirmwareDb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.target()
  @otp_app Mix.Project.config[:app]

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    import Supervisor.Spec, warn: false
    :ok = setup_db!()
    children = [
      FirmwareDb.Repo,
    ]
    opts = [strategy: :one_for_one, name: FirmwareDb.Supervisor]
    Supervisor.start_link(children(@target) ++ children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Starts a worker by calling: FirmwareDb.Worker.start_link(arg)
      # {FirmwareDb.Worker, arg},
    ]
  end

  def children(_target) do
    [
      # Starts a worker by calling: FirmwareDb.Worker.start_link(arg)
      # {FirmwareDb.Worker, arg},
    ]
  end

  defp setup_db! do
    IO.puts "# setup_db!"

    repos = Application.get_env(@otp_app, :ecto_repos)

    for repo <- repos do
      if Application.get_env(@otp_app, repo)[:adapter] == Sqlite.Ecto2 do
        setup_repo!(repo)
        migrate_repo!(repo)
      end
    end
    :ok
  end

  defp setup_repo!(repo) do
    IO.puts "# setup_repo!"

    db_file = Application.get_env(@otp_app, repo)[:database]
    unless File.exists?(db_file) do
      :ok = repo.__adapter__.storage_up(repo.config)
    end
  end

  defp migrate_repo!(repo) do
    IO.puts "# migrate_repo!"

    opts = [all: true]
    {:ok, pid, apps} = Mix.Ecto.ensure_started(repo, opts)

    migrator = &Ecto.Migrator.run/4
    pool = repo.config[:pool]
    migrations_path = Path.join([:code.priv_dir(@otp_app) |> to_string, "repo", "migrations"])
    migrated =
      if function_exported?(pool, :unboxed_run, 2) do
        pool.unboxed_run(repo, fn -> migrator.(repo, migrations_path, :up, opts) end)
      else
        migrator.(repo, migrations_path, :up, opts)
      end

    pid && repo.stop(pid)
    Mix.Ecto.restart_apps_if_migrated(apps, migrated)
  end
end
