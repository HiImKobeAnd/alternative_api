defmodule AlternativeApiWeb.BlogLive.Form do
  use AlternativeApiWeb, :live_view

  alias AlternativeApi.Post
  alias AlternativeApi.Post.Blog

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage blog records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="blog-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:posts]} type="text" label="Posts" />
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:body]} type="textarea" label="Body" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Blog</.button>
          <.button navigate={return_path(@return_to, @blog)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    blog = Post.get_blog!(id)

    socket
    |> assign(:page_title, "Edit Blog")
    |> assign(:blog, blog)
    |> assign(:form, to_form(Post.change_blog(blog)))
  end

  defp apply_action(socket, :new, _params) do
    blog = %Blog{}

    socket
    |> assign(:page_title, "New Blog")
    |> assign(:blog, blog)
    |> assign(:form, to_form(Post.change_blog(blog)))
  end

  @impl true
  def handle_event("validate", %{"blog" => blog_params}, socket) do
    changeset = Post.change_blog(socket.assigns.blog, blog_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"blog" => blog_params}, socket) do
    save_blog(socket, socket.assigns.live_action, blog_params)
  end

  defp save_blog(socket, :edit, blog_params) do
    case Post.update_blog(socket.assigns.blog, blog_params) do
      {:ok, blog} ->
        {:noreply,
         socket
         |> put_flash(:info, "Blog updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, blog))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_blog(socket, :new, blog_params) do
    case Post.create_blog(blog_params) do
      {:ok, blog} ->
        {:noreply,
         socket
         |> put_flash(:info, "Blog created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, blog))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _blog), do: ~p"/post"
  defp return_path("show", blog), do: ~p"/post/#{blog}"
end
