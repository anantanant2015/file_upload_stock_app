defmodule FileUploadStockAppWeb.PageLive.ChartComponent do
  use FileUploadStockAppWeb, :live_component

  # import Phoenix.HTML

  def render(assigns) do
    chart_config = %{
      type: assigns.chart_type,
      chartData: assigns.chart_data,
      chartOptions: assigns.chart_options
    }

    assigns = assign(assigns, :chart_config_json, Jason.encode!(chart_config))

    ~H"""
    <div
      id="chart-wrapper"
      phx-hook="Chart"
      data-chart-config={@chart_config_json}
    >
      <canvas id="price-chart-canvas"></canvas>
    </div>
    """
  end

end
