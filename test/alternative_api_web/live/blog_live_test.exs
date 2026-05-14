defmodule AlternativeApiWeb.BlogLiveTest do
  use AlternativeApiWeb.ConnCase

  import Phoenix.LiveViewTest
  import AlternativeApi.PostFixtures

  @create_attrs %{title: "some title", body: "some body", posts: "some posts"}
  @update_attrs %{title: "some updated title", body: "some updated body", posts: "some updated posts"}
  @invalid_attrs %{title: nil, body: nil, posts: nil}
  defp create_blog(_) do
    blog = blog_fixture()

    %{blog: blog}
  end

  describe "Index" do
    setup [:create_blog]

    test "lists all post", %{conn: conn, blog: blog} do
      {:ok, _index_live, html} = live(conn, ~p"/post")

      assert html =~ "Listing Post"
      assert html =~ blog.posts
    end

    test "saves new blog", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/post")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Blog")
               |> render_click()
               |> follow_redirect(conn, ~p"/post/new")

      assert render(form_live) =~ "New Blog"

      assert form_live
             |> form("#blog-form", blog: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#blog-form", blog: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/post")

      html = render(index_live)
      assert html =~ "Blog created successfully"
      assert html =~ "some posts"
    end

    test "updates blog in listing", %{conn: conn, blog: blog} do
      {:ok, index_live, _html} = live(conn, ~p"/post")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#post-#{blog.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/post/#{blog}/edit")

      assert render(form_live) =~ "Edit Blog"

      assert form_live
             |> form("#blog-form", blog: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#blog-form", blog: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/post")

      html = render(index_live)
      assert html =~ "Blog updated successfully"
      assert html =~ "some updated posts"
    end

    test "deletes blog in listing", %{conn: conn, blog: blog} do
      {:ok, index_live, _html} = live(conn, ~p"/post")

      assert index_live |> element("#post-#{blog.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#post-#{blog.id}")
    end
  end

  describe "Show" do
    setup [:create_blog]

    test "displays blog", %{conn: conn, blog: blog} do
      {:ok, _show_live, html} = live(conn, ~p"/post/#{blog}")

      assert html =~ "Show Blog"
      assert html =~ blog.posts
    end

    test "updates blog and returns to show", %{conn: conn, blog: blog} do
      {:ok, show_live, _html} = live(conn, ~p"/post/#{blog}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/post/#{blog}/edit?return_to=show")

      assert render(form_live) =~ "Edit Blog"

      assert form_live
             |> form("#blog-form", blog: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#blog-form", blog: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/post/#{blog}")

      html = render(show_live)
      assert html =~ "Blog updated successfully"
      assert html =~ "some updated posts"
    end
  end
end
