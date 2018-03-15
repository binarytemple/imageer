defmodule ImageerWeb.UploadControllerTest do
  use ImageerWeb.ConnCase

  alias Imageer.Uploads

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:upload) do
    {:ok, upload} = Uploads.create_upload(@create_attrs)
    upload
  end

  describe "index" do
    test "lists all uploads", %{conn: conn} do
      conn = get conn, upload_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Uploads"
    end
  end

  describe "new upload" do
    test "renders form", %{conn: conn} do
      conn = get conn, upload_path(conn, :new)
      assert html_response(conn, 200) =~ "New Upload"
    end
  end

  describe "create upload" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, upload_path(conn, :create), upload: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == upload_path(conn, :show, id)

      conn = get conn, upload_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Upload"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, upload_path(conn, :create), upload: @invalid_attrs
      assert html_response(conn, 200) =~ "New Upload"
    end
  end

  describe "edit upload" do
    setup [:create_upload]

    test "renders form for editing chosen upload", %{conn: conn, upload: upload} do
      conn = get conn, upload_path(conn, :edit, upload)
      assert html_response(conn, 200) =~ "Edit Upload"
    end
  end

  describe "update upload" do
    setup [:create_upload]

    test "redirects when data is valid", %{conn: conn, upload: upload} do
      conn = put conn, upload_path(conn, :update, upload), upload: @update_attrs
      assert redirected_to(conn) == upload_path(conn, :show, upload)

      conn = get conn, upload_path(conn, :show, upload)
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, upload: upload} do
      conn = put conn, upload_path(conn, :update, upload), upload: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Upload"
    end
  end

  describe "delete upload" do
    setup [:create_upload]

    test "deletes chosen upload", %{conn: conn, upload: upload} do
      conn = delete conn, upload_path(conn, :delete, upload)
      assert redirected_to(conn) == upload_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, upload_path(conn, :show, upload)
      end
    end
  end

  defp create_upload(_) do
    upload = fixture(:upload)
    {:ok, upload: upload}
  end
end
