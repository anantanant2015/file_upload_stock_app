defmodule FileUploadStockApp.Repo.Migrations.CreateDataTable do
  use Ecto.Migration

  def change do
    create table(:data) do
      add :symbol, :string
      add :timestamp, :integer
      add :price, :float

      timestamps()
    end

    create index(:data, [:symbol])
    create index(:data, [:timestamp])
  end
end
