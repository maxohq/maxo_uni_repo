defmodule MiniApp.RepoTest do
  use ExUnit.Case, async: true
  use MnemeDefaults

  setup ctx do
    db = "#{ctx.module}-#{ctx.test}"
    MaxoUniRepo.Connector.connect("file:#{db}?mode=memory")
    MiniApp.Repo.query("create table comments(id, title)")

    MiniApp.Repo.query("insert into comments(id,title) values (1, 'first')")
    MiniApp.Repo.query("insert into comments(id,title) values (2, 'second')")
    :ok

    on_exit(fn ->
      MiniApp.Repo.SqliteRepo |> MaxoUniRepo.RepoSupervisor.stop_child()
    end)

    :ok
  end

  test "1" do
    res = MiniApp.Repo.query("select * from comments")

    auto_assert(
      {:ok,
       %Exqlite.Result{
         columns: ["id", "title"],
         command: :execute,
         num_rows: 2,
         rows: [[1, "first"], [2, "second"]]
       }} <- res
    )
  end

  test "2" do
    MiniApp.Repo.query("insert into comments(id,title) values (3, '3first')")
    res = MiniApp.Repo.query("select * from comments")

    auto_assert(
      {:ok,
       %Exqlite.Result{
         columns: ["id", "title"],
         command: :execute,
         num_rows: 3,
         rows: [[1, "first"], [2, "second"], [3, "3first"]]
       }} <- res
    )
  end
end
