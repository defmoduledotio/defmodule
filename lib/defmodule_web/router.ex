defmodule DefmoduleWeb.Router do
  use DefmoduleWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DefmoduleWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :writing do
    plug DefmoduleWeb.Plugs.Posts
    plug DefmoduleWeb.Plugs.RecentPosts
  end

  scope "/", DefmoduleWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/contact", PageController, :contact
    post "/contact", PageController, :submit_contact
  end

  scope "writing", DefmoduleWeb do
    pipe_through :browser
    pipe_through :writing

    get "/", WritingController, :index
    get "/:id", WritingController, :show
    get "/tags/:id", WritingController, :tags
  end

  # Other scopes may use custom stacks.
  # scope "/api", DefmoduleWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:defmodule, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DefmoduleWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
