# MiniApp

Sample app how MaxoUniRepo should be used.

## Usage

```elixir

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

### Migrations

```
$ mix ecto.migrate
21:31:49.672 [info] == Running 20230423192915 MiniApp.Repo.SqliteRepo.Migrations.AddPosts.change/0 forward

21:31:49.675 [info] create table posts

21:31:49.676 [info] == Migrated 20230423192915 in 0.0s
```
