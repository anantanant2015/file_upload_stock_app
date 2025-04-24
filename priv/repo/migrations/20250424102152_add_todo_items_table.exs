defmodule FileUploadStockApp.Repo.Migrations.AddTodoItemsTable do
  use Ecto.Migration

  def change do
    create table(:todo_items) do
      add :description, :string
      add :timestamp, :integer
      add :status, :boolean, default: false

      timestamps()
    end

    create index(:todo_items, [:id])
  end
end
