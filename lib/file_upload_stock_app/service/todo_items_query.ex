defmodule FileUploadStockApp.TodoItemsService do
  @moduledoc """
  Handles all database querying and insertion logic related to todo list items.
  """

  import Ecto.Query
  alias FileUploadStockApp.{Repo, TodoItems}

  def list_items do
    Repo.all(from d in TodoItems, select: d.description, distinct: true)
  end

  def create_item(item) do
    %TodoItems{}
    |> TodoItems.changeset(item)
    |> Repo.insert()
  end
end
