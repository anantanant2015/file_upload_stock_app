defmodule FileUploadStockAppWeb.Counter do
  use FileUploadStockAppWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:counter_value, nil)
     |> assign(:reset, false)
     |> assign(:trigger_get_value, false)}
  end

  def render(assigns) do
    ~H"""
    <div style="text-align: center;">
      <h2>Parent LiveView</h2>

      <p><strong>Value from Child:</strong> <%= @counter_value || "Not yet fetched" %></p>

      <button phx-click="get_value">Get Value from Child</button>
      <button phx-click="reset_all">Reset Both</button>

      <.live_component
        module={FileUploadStockAppWeb.CounterComponent}
        id="counter"
        reset={@reset}
        trigger_get_value={@trigger_get_value}
      />
    </div>
    """
  end

  def handle_info({:child_value, count}, socket) do
    {:noreply, assign(socket, :counter_value, count)}
  end

  def handle_event("get_value", _params, socket) do
    {:noreply,
     socket
     |> assign(:trigger_get_value, true)
     |> assign(:reset, false)}
  end

  def handle_event("reset_all", _params, socket) do
    {:noreply,
     socket
     |> assign(:reset, true)
     |> assign(:trigger_get_value, false)
     |> assign(:counter_value, 0)}
  end
end
