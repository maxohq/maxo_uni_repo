defmodule MaxoUniRepo.Config do
  def main_repo do
    from_env(:main_repo)
  end

  def main_app do
    from_env(:main_app)
  end

  def valid_db_types do
    from_env(:db_types, ["mysql", "psql", "sqlite"])
  end

  def sqlite_repo do
    Module.concat([main_repo(), :SqliteRepo])
  end

  def mysql_repo do
    Module.concat([main_repo(), :MysqlRepo])
  end

  def psql_repo do
    Module.concat([main_repo(), :PsqlRepo])
  end

  def from_env(key, default \\ nil) do
    Application.get_env(:maxo_uni_repo, key, default)
  end
end
