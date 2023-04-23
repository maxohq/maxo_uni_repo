# MaxoUniRepo

[![CI](https://github.com/maxohq/maxo_uni_repo/actions/workflows/ci.yml/badge.svg?style=flat)](https://github.com/maxohq/maxo_uni_repo/actions/workflows/ci.yml)
[![Hex.pm](https://img.shields.io/hexpm/v/maxo_uni_repo.svg?style=flat)](https://hex.pm/packages/maxo_uni_repo)
[![Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg?style=flat)](https://hexdocs.pm/maxo_uni_repo)
[![Total Download](https://img.shields.io/hexpm/dt/maxo_uni_repo.svg?style=flat)](https://hex.pm/packages/maxo_uni_repo)
[![License](https://img.shields.io/hexpm/l/maxo_uni_repo.svg?style=flat)](https://github.com/maxohq/maxo_uni_repo/blob/main/LICENCE)

`MaxoUniRepo` helps you to support multiple DB engines with runtime DB switching all with a single Ecto Repo module.

## Usage

```elixir
# Step 1: define your main repo
# - it will proxy requests to DB-specific repos
defmodule MiniApp.Repo do
  use MaxoUniRepo.EctoBehaviour, validate: false
end


# Step 2: define how your DB specific repos should look
# - will generate 3 in-memory repo modules for each DB type(psql / mysql / sqlite)
# - if you need any modifications (like pagination / soft-delete, etc), this is the place to implements it
defmodule MiniApp.RepoSetup do
  use MaxoUniRepo.RepoSetup

  common do
    @impl true
    def init(_context, config), do: {:ok, config}
  end
end


# Step 3: Configure the application to start the RepoSupervisor + setup default DB
defmodule MiniApp.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Do not start the main repo directly, but start the RepoSupervisor to manage our repos
      MaxoUniRepo.RepoSupervisor
    ]

    opts = [strategy: :one_for_one, name: MiniApp.Supervisor]
    res = Supervisor.start_link(children, opts)

    # Configure the default in-memory Sqlite DB after the RepoSupervisor started
    MaxoUniRepo.Setup.to_sqlite(true)
    res
  end
end


# Step 4: now provide the config for maxo_uni_repo + our default repo:
## in config/config.exs
import Config

## Configure maxo_uni_repo to use our "proxy" Repo + which app we are targetting
config :maxo_uni_repo, main_repo: MiniApp.Repo
config :maxo_uni_repo, main_app: :mini_app

## Default setup for mini_app repos, so mix generators work properly
config :mini_app, ecto_repos: [MiniApp.Repo.SqliteRepo]

config :mini_app, MiniApp.Repo.SqliteRepo,
  database: "./data/sqlite.db",
  priv: "priv/repo"

##########################################################################
### Now you can start using the MiniApp.Repo with the configured Sqlite DB
### and also switch at runtime to any other DB
##########################################################################

# Use the pre-configured Sqlite DB
iex> MiniApp.Repo.query("create table users(id, name)")
{:ok, %Exqlite.Result{command: :execute, columns: [], rows: [], num_rows: 0}}

iex> MiniApp.Repo.query("insert into users(id, name) values (1, 'first')")
{:ok, %Exqlite.Result{command: :execute, columns: [], rows: [], num_rows: 0}}

iex> MiniApp.Repo.query("select count(id) from users")
{:ok,
 %Exqlite.Result{
   command: :execute,
   columns: ["count(id)"],
   rows: [[1]],
   num_rows: 1
 }}

# switch to an in-memory Sqlite db
iex> MaxoUniRepo.Connector.connect("file:new.db?mode=memory&cache=shared")
[debug] [MaxoAdapt] Linked `MiniApp.Repo` to implementation `MiniApp.Repo.SqliteRepo`.
:ok


iex> MiniApp.Repo.query("select count(id) from users")
{:error,
 %Exqlite.Error{
   message: "no such table: users",
   statement: "select count(id) from users"
 }}


# Switch to a Postgres DB
iex> MaxoUniRepo.Connector.connect("postgres://postgres:postgres@localhost:5432/postgres")
[debug] [MaxoAdapt] Linked `MiniApp.Repo` to implementation `MiniApp.Repo.PsqlRepo`.
:ok

# The users table does not exist here
iex> MiniApp.Repo.query("select count(id) from users")
{:error,
 %Postgrex.Error{
   message: nil,
   postgres: %{
     code: :undefined_table,
     file: "parse_relation.c",
     line: "1384",
     message: "relation \"users\" does not exist",
     pg_code: "42P01",
     position: "23",
     routine: "parserOpenTable",
     severity: "ERROR",
     unknown: "ERROR"
   },
   connection_id: 978,
   query: "select count(id) from users"
 }}
```

## Installation

The package can be installed by adding `maxo_uni_repo` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:maxo_uni_repo, "~> 0.1"}
  ]
end
```

The docs can be found at <https://hexdocs.pm/maxo_uni_repo>.

## Support

<p>
  <a href="https://quantor.consulting/?utm_source=github&utm_campaign=maxo_uni_repo">
    <img src="https://raw.githubusercontent.com/maxohq/sponsors/main/assets/quantor_consulting_logo.svg"
      alt="Sponsored by Quantor Consulting" width="210">
  </a>
</p>

## License

The lib is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
