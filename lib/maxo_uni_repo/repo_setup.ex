defmodule MaxoUniRepo.RepoSetup do
  @moduledoc """
  Convenience module to help you quickly generate 3 repos.
  For special requirements those can be also implemented in the manual way, without MaxoUniRepo.RepoSetup.
  """

  alias MaxoUniRepo.Config

  defmacro __using__(_) do
    quote do
      require MaxoUniRepo.RepoSetup
      import MaxoUniRepo.RepoSetup
    end
  end

  @doc """
  Generates during compile-time 3 repo modules for each supported DB driver.
  """
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
