defmodule Imageer.Router do
  use Imageer.Web, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    # plug :protect_from_forgery
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", Imageer do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    resources("/images", ImageController)
    resources("/uploads", UploadController)

  end

  # Other scopes may use custom stacks.
  # scope "/api", Imageer do
  #   pipe_through :api
  # end
end