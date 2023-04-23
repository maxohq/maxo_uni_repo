defmodule MaxoUniRepo.RepoSupervisor do
  @moduledoc """
  Dynamic supervisor to enable clean runtime switching for repo configuration
  """
  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def start_child(repo) do
    spec = %{id: repo, start: {repo, :start_link, []}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def start_child(repo, opts) when is_list(opts) do
    spec = %{id: repo, start: {repo, :start_link, [opts]}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def stop_child(repo) do
    pid = pid_for_repo(repo)

    if pid do
      DynamicSupervisor.terminate_child(__MODULE__, pid)
    end
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def children do
    DynamicSupervisor.which_children(__MODULE__)
  end

  def pid_for_repo(repo) do
    res =
      children()
      |> Enum.filter(fn x ->
        {_, _pid, _, [r]} = x
        r == repo
      end)

    case res do
      [{_, pid, _, _}] -> pid
      [] -> nil
    end
  end
end
