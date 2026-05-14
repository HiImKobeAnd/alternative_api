defmodule AlternativeApiWeb.Router do
  use AlternativeApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html", "json"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AlternativeApiWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug AlternativeApiWeb.Plugs.Locale, "en"
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug AlternativeApiWeb.Authentication
  end

  scope "/", AlternativeApiWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/hello", HelloController, :index
    get "/hello/:messenger", HelloController, :show

    resources "/users", UserController do
      resources "/posts", PostController
    end

    resources "/comments", CommentController, except: [:delete]
    resources "/reviews", ReviewController

    live "/post", BlogLive.Index, :index
    live "/post/new", BlogLive.Form, :new
    live "/post/:id", BlogLive.Show, :show
    live "/post/:id/edit", BlogLive.Form, :edit
  end

  scope "/admin", AlternativeApiWeb.Admin do
    pipe_through :browser
    resources "/images", ImageController
    resources "/reviews", ReviewController
    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  scope "/api", AlternativeApiWeb do
    pipe_through [:api]
    resources "/urls", UrlController, except: [:new, :edit]
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:alternative_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AlternativeApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
