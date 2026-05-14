defmodule AlternativeApiWeb.BlogLive.Show do
  use AlternativeApiWeb, :live_view

  alias AlternativeApi.Post

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Blog {@blog.id}
        <:subtitle>This is a blog record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/post"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/post/#{@blog}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit blog
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Posts">{@blog.posts}</:item>
        <:item title="Title">{@blog.title}</:item>
        <:item title="Body">{@blog.body}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Blog")
     |> assign(:blog, Post.get_blog!(id))}
  end
end
