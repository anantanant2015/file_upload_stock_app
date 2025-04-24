defmodule FileUploadStockAppWeb.Todo.InputItem do
  use FileUploadStockAppWeb, :live_component

  alias FileUploadStockApp.TodoItemsService
  # import Phoenix.HTML

  def render(assigns) do
    ~H"""
    <div>
      <.form for={@form} phx-submit="add-to-list">
        <.input type="text" field={@form[:description]} />
        <button>Add to list</button>
      </.form>
    </div>
    """
  end
end
