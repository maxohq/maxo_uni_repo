import Config

## Configure maxo_uni_repo to use our "proxy" Repo + which app we are targetting
config :maxo_uni_repo, main_repo: MiniApp.Repo
config :maxo_uni_repo, main_app: :mini_app

## Default setup for mini_app repos, so mix generators work properly
config :mini_app, ecto_repos: [MiniApp.Repo.SqliteRepo]

config :mini_app, MiniApp.Repo.SqliteRepo,
  database: "./data/sqlite.db",
  priv: "priv/repo"
