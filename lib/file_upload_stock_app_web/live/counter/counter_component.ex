defmodule FileUploadStockAppWeb.CounterComponent do
  use Phoenix.LiveComponent

  def mount(socket) do
    {:ok, assign_new(socket, :count, fn -> 0 end)}
  end

  def update(%{reset: true} = assigns, socket) do
    socket =
      socket
      |> assign(:count, 0)
      |> assign(:reset, false)

    {:ok, assign(socket, assigns)}
  end

  def update(%{trigger_get_value: true} = assigns, socket) do
    # Send value to parent
    send(self(), {:child_value, socket.assigns.count})

    socket =
      socket
      |> assign(:trigger_get_value, false)

    {:ok, assign(socket, assigns)}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  def handle_event("inc", _params, socket) do
    {:noreply, update(socket, :count, &(&1 + 1))}
  end

  def render(assigns) do
    ~H"""
    <div style="margin-top: 20px; border: 1px solid gray; padding: 10px;">
      <h3>Child Component</h3>
      <p>Counter: <%= @count %></p>
      <button phx-click="inc" phx-target={@myself}>Increment</button>
    </div>
    """
  end
end
