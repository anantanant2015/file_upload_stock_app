defmodule FileUploadStockAppWeb.Todo do
  require Logger
  use FileUploadStockAppWeb, :live_view

  alias FileUploadStockApp.TodoItemsService
  alias FileUploadStockApp.TodoItems

  # alias Phoenix.LiveView.JS

  def mount(_params, _session, socket) do
    todos = TodoItemsService.list_items()
    form = TodoItems.empty_changeset() |> to_form()

    {:ok, socket |> assign(:todos, todos) |> assign(:form, form) |> assign(:info, "")}
  end

  def handle_event("add-to-list", %{"todo_items" => todo_item}, socket) do
    case TodoItemsService.create_item(todo_item) do
      {:ok, _item} ->
        {:noreply,
         socket
         |> put_flash(:info, "Item created")
         |> redirect(to: ~p"/todo/")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  %{params: %{"status" => true}, event: "inc"}

  def handle_event("update", params, socket) do
    case TodoItemsService.update_item(params) do
      {:ok, _item} = res ->
        IO.inspect(res)

        {:noreply,
         socket
         |> put_flash(:info, "Item updated")
         |> redirect(to: ~p"/todo/")}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event(event, params, socket) do
    IO.inspect(%{event: event, params: params})
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <div>{@info}</div>
      <.live_component
        module={FileUploadStockAppWeb.Todo.InputItem}
        id="todo-input-component"
        form={@form}
      />
      <table class="stripes">
        <thead>
          <tr>
            <th>ID</th>
            <th>Description</th>
            <th>Status</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          <div class="todo-list">
            <%= for item <- @todos do %>
              <tr>
                <td>{Map.get(item, :id)}</td>
                <td>{Map.get(item, :description)}</td>
                <td>
                  <label
                    class="switch"
                    phx-click={JS.push("update", value: %{status: !item.status, id: item.id})}
                  >
                    <input
                      type="checkbox"
                      id="status#{item.id}"
                      checked={item.status}
                      value={item.status}
                    />
                    <span></span>
                  </label>
                </td>
                <td><button>delete</button></td>
              </tr>
            <% end %>
          </div>
        </tbody>
      </table>
    </div>
    """
  end
end
