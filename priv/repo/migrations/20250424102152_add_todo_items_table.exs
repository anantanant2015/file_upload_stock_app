defmodule FileUploadStockApp.Repo.Migrations.AddTodoItemsTable do
  use Ecto.Migration

  def change do
  create table(:todo_items) do
    add :description, :string
    add :timestamp, :integer

    timestamps()
  end

  create index(:data, [:timestamp])

  end
end
