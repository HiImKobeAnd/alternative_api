defmodule AlternativeApi.PostFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AlternativeApi.Post` context.
  """

  @doc """
  Generate a blog.
  """
  def blog_fixture(attrs \\ %{}) do
    {:ok, blog} =
      attrs
      |> Enum.into(%{
        body: "some body",
        posts: "some posts",
        title: "some title"
      })
      |> AlternativeApi.Post.create_blog()

    blog
  end
end
