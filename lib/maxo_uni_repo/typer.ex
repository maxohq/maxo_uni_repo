defmodule MaxoUniRepo.Typer do
  alias MaxoUniRepo.Config

  @repo_types %{
    Ecto.Adapters.MyXQL => :mysql,
    Ecto.Adapters.Postgres => :psql,
    Ecto.Adapters.SQLite3 => :sqlite
  }

  def repo_type(repo) do
    adapter = repo.__adapter__()
    Map.fetch!(@repo_types, adapter)
  end

  def url_type(url) do
    cond do
      String.starts_with?(url, "postgres:") -> :psql
      String.starts_with?(url, "mysql:") -> :mysql
      String.starts_with?(url, "file:") -> :sqlite
      true -> raise "NO known DB type for #{url}!"
    end
  end

  @doc "Returns the right repo for a type"
  def repo_for_type(:mysql), do: Config.mysql_repo()
  def repo_for_type(:psql), do: Config.psql_repo()
  def repo_for_type(:sqlite), do: Config.sqlite_repo()

  # also for strings
  def repo_for_type("mysql"), do: Config.mysql_repo()
  def repo_for_type("psql"), do: Config.psql_repo()
  def repo_for_type("sqlite"), do: Config.sqlite_repo()

  def repo_for_type(t), do: raise("NO known Repo for type #{t}!")

  @doc "Returns driver app for type"
  def app_for_type(:mysql), do: :myxql
  def app_for_type(:psql), do: :postgrex
  def app_for_type(:sqlite), do: :exqlite
  def app_for_type(t), do: raise("NO known app for type #{t}!")
end
