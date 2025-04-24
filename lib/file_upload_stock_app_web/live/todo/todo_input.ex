defmodule FileUploadStockAppWeb.Todo.InputItem do
  use FileUploadStockAppWeb, :live_component

  alias FileUploadStockApp.TodoItemsService
  # import Phoenix.HTML

  def render(assigns) do
    ~H"""
    <div>
      <.form for={@form} phx-submit="add-to-list">
        <.input type="text" field={@form[:user_input]} />
        <button>Add to list</button>
      </.form>
    </div>
    """
  end

  def handle_event("add-to-list", %{"user_input" => _user_input} = params, socket) do
    case TodoItemsService.create_item(params) do
      {:ok, _item} ->
        {:noreply,
         socket
         |> put_flash(:info, "Item created")
         |> redirect(to: ~p"/todo/")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
    {:ok, assign(socket, todos: TodoItemsService.list_items())}
  end
end
