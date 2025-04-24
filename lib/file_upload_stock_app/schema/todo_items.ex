defmodule FileUploadStockApp.TodoItems do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todo_items" do
    field :description, :string
    field :timestamp, :integer
    field :status, :boolean, default: false

    timestamps()
  end

  def changeset(data, attrs) do
    updated_attrs = attrs |> Map.put("timestamp", DateTime.utc_now() |> DateTime.to_unix())

    data
    |> cast(updated_attrs, [:description, :timestamp, :status])
    |> validate_required([:description, :timestamp, :status])
  end

  def update_changeset(data, attrs) do
    updated_attrs = attrs |> Map.put(:timestamp, DateTime.utc_now() |> DateTime.to_unix())

    data
    |> cast(updated_attrs, [:description, :timestamp, :status])
    |> validate_required([:description, :timestamp, :status])
  end

  def empty_changeset() do
    %FileUploadStockApp.TodoItems{} |> changeset(Map.new())
  end

  def get_readable_errors(changeset) do
    traverse_errors(changeset, fn {msg, opts} ->
      Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
