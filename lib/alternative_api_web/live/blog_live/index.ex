defmodule AlternativeApiWeb.BlogLive.Index do
  use AlternativeApiWeb, :live_view

  alias AlternativeApi.Post

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Post
        <:actions>
          <.button variant="primary" navigate={~p"/post/new"}>
            <.icon name="hero-plus" /> New Blog
          </.button>
        </:actions>
      </.header>

      <.table
        id="post"
        rows={@streams.post}
        row_click={fn {_id, blog} -> JS.navigate(~p"/post/#{blog}") end}
      >
        <:col :let={{_id, blog}} label="Posts">{blog.posts}</:col>
        <:col :let={{_id, blog}} label="Title">{blog.title}</:col>
        <:col :let={{_id, blog}} label="Body">{blog.body}</:col>
        <:action :let={{_id, blog}}>
          <div class="sr-only">
            <.link navigate={~p"/post/#{blog}"}>Show</.link>
          </div>
          <.link navigate={~p"/post/#{blog}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, blog}}>
          <.link
            phx-click={JS.push("delete", value: %{id: blog.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Post")
     |> stream(:post, list_post())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    blog = Post.get_blog!(id)
    {:ok, _} = Post.delete_blog(blog)

    {:noreply, stream_delete(socket, :post, blog)}
  end

  defp list_post() do
    Post.list_post()
  end
end
