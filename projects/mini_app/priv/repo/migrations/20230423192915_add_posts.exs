defmodule MiniApp.Repo.SqliteRepo.Migrations.AddPosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string, size: 200, null: false
      add :body, :text, size: 200, null: false
      add :published_at, :utc_datetime
      timestamps()
    end
  end
end
