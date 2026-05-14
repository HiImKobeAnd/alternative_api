defmodule AlternativeApi.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:post) do
      add :posts, :string
      add :title, :string
      add :body, :text

      timestamps(type: :utc_datetime)
    end
  end
end
