defmodule AlternativeApi.PostTest do
  use AlternativeApi.DataCase

  alias AlternativeApi.Post

  describe "post" do
    alias AlternativeApi.Post.Blog

    import AlternativeApi.PostFixtures

    @invalid_attrs %{title: nil, body: nil, posts: nil}

    test "list_post/0 returns all post" do
      blog = blog_fixture()
      assert Post.list_post() == [blog]
    end

    test "get_blog!/1 returns the blog with given id" do
      blog = blog_fixture()
      assert Post.get_blog!(blog.id) == blog
    end

    test "create_blog/1 with valid data creates a blog" do
      valid_attrs = %{title: "some title", body: "some body", posts: "some posts"}

      assert {:ok, %Blog{} = blog} = Post.create_blog(valid_attrs)
      assert blog.title == "some title"
      assert blog.body == "some body"
      assert blog.posts == "some posts"
    end

    test "create_blog/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Post.create_blog(@invalid_attrs)
    end

    test "update_blog/2 with valid data updates the blog" do
      blog = blog_fixture()
      update_attrs = %{title: "some updated title", body: "some updated body", posts: "some updated posts"}

      assert {:ok, %Blog{} = blog} = Post.update_blog(blog, update_attrs)
      assert blog.title == "some updated title"
      assert blog.body == "some updated body"
      assert blog.posts == "some updated posts"
    end

    test "update_blog/2 with invalid data returns error changeset" do
      blog = blog_fixture()
      assert {:error, %Ecto.Changeset{}} = Post.update_blog(blog, @invalid_attrs)
      assert blog == Post.get_blog!(blog.id)
    end

    test "delete_blog/1 deletes the blog" do
      blog = blog_fixture()
      assert {:ok, %Blog{}} = Post.delete_blog(blog)
      assert_raise Ecto.NoResultsError, fn -> Post.get_blog!(blog.id) end
    end

    test "change_blog/1 returns a blog changeset" do
      blog = blog_fixture()
      assert %Ecto.Changeset{} = Post.change_blog(blog)
    end
  end
end
