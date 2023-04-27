defmodule MiniApp.Repo2Test do
  use ExUnit.Case, async: true
  use MnemeDefaults

  setup :setup_db

  test "works2" do
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

  test "works3" do
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

  def setup_db(_) do
    MaxoUniRepo.Connector.connect("file:./check.db?mode=memory&cache=shared")

    {:ok, %Exqlite.Result{command: :execute, columns: [], rows: [], num_rows: 0}} =
      MiniApp.Repo.query("create table comments(id, title)")

    MiniApp.Repo.query("insert into comments(id,title) values (1, 'first')")
    MiniApp.Repo.query("insert into comments(id,title) values (2, 'second')")

    :ok
  end
end
