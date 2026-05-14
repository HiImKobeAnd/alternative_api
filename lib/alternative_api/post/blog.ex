defmodule AlternativeApi.Post.Blog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "post" do
    field :posts, :string
    field :title, :string
    field :body, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(blog, attrs) do
    blog
    |> cast(attrs, [:posts, :title, :body])
    |> validate_required([:posts, :title, :body])
  end
end
