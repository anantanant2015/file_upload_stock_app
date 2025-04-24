defmodule FileUploadStockApp.TodoItems do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todo_items" do
    field :description, :string
    field :timestamp, :integer

    timestamps()
  end

  def changeset(data, attrs) do
    data
    |> cast(attrs, [:description, :timestamp])
    |> validate_required([:description, :timestamp])
  end
end
