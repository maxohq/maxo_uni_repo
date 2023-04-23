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
