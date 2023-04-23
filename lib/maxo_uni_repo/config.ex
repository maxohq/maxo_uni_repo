defmodule MaxoUniRepo.Config do
  @moduledoc """
  All configuration options for `:maxo_uni_repo` package
  """

  @doc "The module name for the main repo, eg: `MyApp.Repo`"
  def main_repo, do: from_env(:main_repo)

  @doc "The main application name , eg: `:my_app`"
  def main_app, do: from_env(:main_app)

  @doc false
  def valid_db_types, do: from_env(:db_types, ["psql", "mysql", "sqlite"])

  def dbtype_env_name, do: from_env(:dbtype_env_name, "DBTYPE")

  @doc """
  Repo responsible for Sqlite
  - defaults to runtime generated module like `MyApp.Repo.SqliteRepo`
  """
  def sqlite_repo, do: from_env(:sqlite_repo, repo_mod(:SqliteRepo))

  @doc """
  Repo responsible for MySQL
  - defaults to runtime generated module like `MyApp.Repo.MysqlRepo`
  """
  def mysql_repo, do: from_env(:mysql_repo, repo_mod(:MysqlRepo))

  @doc """
  Repo responsible for Postgres
  - defaults to runtime generated module like `MyApp.Repo.PsqlRepo`
  """
  def psql_repo, do: from_env(:psql_repo, repo_mod(:PsqlRepo))

  def from_env(key, default \\ nil) do
    Application.get_env(:maxo_uni_repo, key, default)
  end

  defp repo_mod(postfix) do
    Module.concat([main_repo(), postfix])
  end
end
