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

  alias MaxoUniRepo.Typer
  alias MaxoUniRepo.Setup

  def connect(url) do
    type = Typer.url_type(url)
    repo = Typer.repo_for_type(type)
    opts = opts_for(type, url)
    Setup.start_dynamic(repo, opts)
  end

  defp opts_for(:sqlite, url) do
    [database: url, priv: "priv/repo"]
  end

  defp opts_for(type, url) when type in [:psql, :mysql] do
    [url: url, priv: "priv/repo"]
  end
end
