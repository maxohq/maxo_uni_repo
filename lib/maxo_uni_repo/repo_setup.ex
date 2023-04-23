defmodule MaxoUniRepo.RepoSetup do
  alias MaxoUniRepo.Config

  defmacro __using__(_) do
    quote do
      require MaxoUniRepo.RepoSetup
      import MaxoUniRepo.RepoSetup
    end
  end

  defmacro common(do: block) do
    quote do
      defmodule unquote(Config.psql_repo()) do
        use Ecto.Repo,
            unquote(repo_opts_for(Ecto.Adapters.Postgres))

        unquote(block)
      end

      defmodule unquote(Config.mysql_repo()) do
        use Ecto.Repo,
            unquote(repo_opts_for(Ecto.Adapters.MyXQL))

        unquote(block)
      end

      defmodule unquote(Config.sqlite_repo()) do
        use Ecto.Repo,
            unquote(repo_opts_for(Ecto.Adapters.SQLite3))

        unquote(block)
      end
    end
  end

  def repo_opts_for(adapter) do
    Keyword.merge(
      [adapter: adapter, priv: "priv/repo"],
      otp_app: Config.main_app()
    )
  end
end
