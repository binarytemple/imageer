defmodule Imageer.Uploads.Upload do
  use Ecto.Schema
  import Ecto.Changeset


  schema "uploads" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(upload, attrs) do
    

    upload
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
