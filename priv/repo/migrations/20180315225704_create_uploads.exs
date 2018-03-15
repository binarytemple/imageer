defmodule Imageer.Repo.Migrations.CreateUploads do
  use Ecto.Migration

  def change do
    create table(:uploads) do
      add :name, :string

      timestamps()
    end

  end
end
