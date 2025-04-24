defmodule FileUploadStockAppWeb.Todo do
  require Logger
  use FileUploadStockAppWeb, :live_view

  alias FileUploadStockApp.TodoItemsService

  # alias Phoenix.LiveView.JS

  def mount(params, _session, socket) do
    new_socket =
      with {:ok, item} <- TodoItemsService.create_item(params) do
        assign(socket, :info, "New list item inserted with id: #{item.id}")
      else
        error ->
          IO.inspect(error)

          assign(
            socket,
            :info,
            "New list item insert resulted with error: #{Jason.encode!(error)}"
          )
      end

    {:ok, new_socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <div><%= @info %></div>
      <.live_component module={FileUploadStockAppWeb.Todo.InputItem} id="todo-input-component" />

      <div class="todo-list">
          <%= for item <- @todos do %>
            <div style="margin-top: 10px;">
              <strong><%= item.description %></strong>
            </div>
          <% end %>
        </div>
    </div>
    """
  end
end
