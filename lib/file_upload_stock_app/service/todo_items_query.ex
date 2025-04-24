defmodule FileUploadStockApp.TodoItemsService do
  @moduledoc """
  Handles all database querying and insertion logic related to todo list items.
  """

  import Ecto.Query
  alias FileUploadStockApp.{Repo, TodoItems}

  def list_items do
    Repo.all(from d in TodoItems, select: d, distinct: true)
  end

  def create_item(item) do
    %TodoItems{}
    |> TodoItems.changeset(item)
    |> Repo.insert()
  end

  def update_item(%{"id" => id, "status" => status}) do
    case Repo.get(TodoItems, id) do
      nil ->
        {:error, :not_found}

      todo ->
        changeset = TodoItems.update_changeset(todo, %{status: status})
        Repo.update(changeset)
    end
  end
end
