defmodule MaxoUniRepo.Connector do
  @moduledoc """
  Runtime dynamic connector based on URL

  Examples:

  ```elixir
  iex> MaxoUniRepo.Connector.connect("file:./check.db?mode=memory&cache=shared")
  iex> MaxoUniRepo.Connector.connect("postgres://postgres:postgres@localhost:5432/postgres")
  iex> MaxoUniRepo.Connector.connect("mysql://root:mysql@localhost:5552/my_db")
  ```
  Test:

  ```elixir
  iex> MyApp.Repo.query("select count(*) from users")
  iex> MyApp.Repo.query("select * from users limit 1")
  ```

  """

  alias MaxoUniRepo.Config

  def connect(url) do
    {repo, opts} =
      cond do
        String.starts_with?(url, "postgres:") -> {Config.psql_repo(), normal_params(url)}
        String.starts_with?(url, "mysql:") -> {Config.mysql_repo(), normal_params(url)}
        String.starts_with?(url, "file:") -> {Config.sqlite_repo(), sqlite_params(url)}
      end

    MaxoUniRepo.Setup.start_dynamic(repo, opts)
  end

  defp normal_params(url) do
    [
      url: url,
      priv: "priv/repo"
    ]
  end

  defp sqlite_params(url) do
    [
      database: url,
      priv: "priv/repo"
    ]
  end
end
