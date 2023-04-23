defmodule MiniApp.RepoSetup do
  use MaxoUniRepo.RepoSetup

  common do
    @impl true
    def init(_context, config), do: {:ok, config}
  end
end
