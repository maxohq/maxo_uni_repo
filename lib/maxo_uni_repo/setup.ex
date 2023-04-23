defmodule MaxoUniRepo.Setup do
  @moduledoc """
  Setup module to contain logic how to cleanly switch between different repositories
  - also how to configure the main Ecto repo on boot
  """
  alias MaxoUniRepo.Config
  alias MaxoUniRepo.Typer

  def setup_repo!(boot \\ true) do
    assert_correct_db_type!()
    if dbtype?("mysql"), do: to_mysql(boot)
    if dbtype?("psql"), do: to_psql(boot)
    if dbtype?("sqlite"), do: to_sqlite(boot)
  end

  def assert_correct_db_type! do
    if dbtype() not in Config.valid_db_types() do
      dbtypes = Enum.join(Config.valid_db_types(), " / ")
      raise "PLEASE PROVIDE `#{Config.dbtype_env_name()}` ENV variable - #{dbtypes}!"
    end
  end

  def repo_module(), do: Typer.repo_for_type(dbtype())

  def dbtype, do: System.get_env(Config.dbtype_env_name())
  def dbtype?(type), do: dbtype() == type

  def to_mysql(boot \\ true), do: ensure_repo_started(:myxql, Config.mysql_repo(), boot)
  def to_psql(boot \\ true), do: ensure_repo_started(:postgrex, Config.psql_repo(), boot)
  def to_sqlite(boot \\ true), do: ensure_repo_started(:exqlite, Config.sqlite_repo(), boot)

  def setup_env(repo \\ nil) do
    repo = if repo, do: repo, else: repo_module()
    Application.put_env(Config.main_app(), :ecto_repos, [repo])
  end

  defp ensure_repo_started(db_app, repo_mod, start_repo) do
    ensure_current_stopped()
    setup_env(repo_mod)
    :application.ensure_all_started(:ecto_sql)
    :application.ensure_all_started(db_app)
    if start_repo, do: MaxoUniRepo.RepoSupervisor.start_child(repo_mod)
    Config.main_repo().configure(repo_mod)
  end

  def start_dynamic(repo_mod, opts) do
    ensure_current_stopped()
    setup_env(repo_mod)
    db_app = Typer.repo_type(repo_mod) |> Typer.app_for_type()
    :application.ensure_all_started(db_app)
    MaxoUniRepo.RepoSupervisor.start_child(repo_mod, opts)
    Config.main_repo().configure(repo_mod)
  end

  def ensure_current_stopped do
    if mod = Config.main_repo().maxo_adapt() do
      MaxoUniRepo.RepoSupervisor.stop_child(mod)
    end
  end
end
