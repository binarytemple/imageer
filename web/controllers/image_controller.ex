defmodule Imageer.ImageController do
  import Logger
  use Imageer.Web, :controller
  alias Imageer.Image
  # alias Imageer.Repo

  def index(conn, _) do
    render(conn, "index.html")
  end

  def new(conn, _) do
    changeset = Image.changeset(%Image{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"image" => image_params}) do
    error(image_params, conn)
  end
end
