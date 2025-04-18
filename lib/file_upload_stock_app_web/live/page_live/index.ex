defmodule FileUploadStockAppWeb.PageLive do
  @moduledoc """
  LiveView page for uploading TSV files and rendering charts based on stock data.
  """

  require Logger
  use FileUploadStockAppWeb, :live_view

  alias Phoenix.LiveView.JS
  alias FileUploadStockApp.{FileUtils, DataQuery, ChartDataConverter}

  @default_chart_type "scatter"
  @default_chart_data %{
    labels: ["Red", "Blue", "Yellow", "Green", "Purple", "Orange"],
    datasets: [
      %{
        label: "# of Votes",
        data: [12, 19, 3, 5, 2, 3],
        borderWidth: 1
      }
    ]
  }
  @default_chart_options %{
    scales: %{
      x: %{
        type: "linear",
        position: "bottom"
      }
    }
  }

  @impl true
  def mount(_params, _session, socket) do
    {:ok, load_default_assigns(socket)}
  end

  defp load_default_assigns(socket) do
    has_data = DataQuery.has_data?()

    socket
    |> assign(:has_data, has_data)
    |> assign(:show_demo_button, not has_data)
    |> assign(:chart_type, @default_chart_type)
    |> assign(:chart_data, @default_chart_data)
    |> assign(:chart_options, @default_chart_options)
    |> assign(:symbols, if(has_data, do: DataQuery.list_unique_symbols(), else: []))
    |> assign(:selected_symbol, nil)
    |> assign(:aggregation, "hourly")
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, load_default_assigns(socket)}
  end

  def handle_event("generate_demo", _params, socket) do
    paths = FileUploadStockApp.GenerateRandomFiles.generate_files()
    send(self(), {:uploaded, paths})
    {:noreply, socket}
  end

  @impl true
  def handle_event("upload", %{"file" => file}, socket) do
    with {:ok, path} <- FileUtils.save_file(file),
         {:ok, data} <- FileUtils.parse_tsv(path),
         :ok <- DataQuery.insert_data(data) do
      {:noreply, socket}
    else
      _ -> {:noreply, socket}
    end
  end

  @impl true
  def handle_event(
        "update_chart",
        %{
          "symbol" => symbol,
          "aggregation" => aggregation,
          "chart_type" => _chart_type
        } = assigns,
        socket
      ) do
    data =
      DataQuery.fetch_aggregated_data(symbol, String.to_existing_atom(aggregation))
      |> Enum.map(&convert_to_chart_point/1)
      |> ChartDataConverter.to_chart_data(assigns)

    chart_params = %{
      type: data.type,
      chartData: data.data,
      chartOptions: data.options
    }

    {:noreply,
     socket
     |> push_event("render_vega_chart", chart_params)
     |> assign(:selected_symbol, symbol)
     |> assign(:aggregation, aggregation)
     |> assign(:chart_data, data.data)
     |> assign(:chart_type, data.type)
     |> assign(:chart_options, data.options)}
  end

  def handle_event("delete_all_data", _params, socket) do
    DataQuery.delete_all_data()
    {:noreply, push_patch(socket, to: ~p"/")}
  end

  @impl true
  def handle_info({:uploaded, paths}, socket) do
    Logger.info(paths, label: "Uploaded TSV Files")

    parsed_file_data =
      paths
      |> Enum.map(fn path -> FileUtils.parse_tsv(path) end)
      |> List.flatten()

    status = DataQuery.insert_data(parsed_file_data)
    Logger.warning("Inserting data status: #{inspect(status)}")

    {:noreply, push_patch(socket, to: ~p"/")}
  end

  defp convert_to_chart_point(%{timestamp: ts, avg_price: price}) do
    %{
      timestamp: ts |> DateTime.to_iso8601() |> String.split("T") |> hd(),
      avg_price: price
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.live_component module={FileUploadStockAppWeb.PageLive.FileUploadComponent} id="tsv-uploader" />

      <br />
      <%= if !(@show_demo_button) do %>
        <div class="controls">
          <form phx-submit="update_chart">
            <label for="symbol">Select Symbol:</label>
            <select name="symbol" id="symbol" class="border no-round max large">
              <%= for sym <- @symbols do %>
                <option value={sym} selected={sym == @selected_symbol}>{sym}</option>
              <% end %>
            </select>

            <label for="aggregation">Select Aggregation:</label>
            <select name="aggregation" id="aggregation" class="border no-round max large">
              <option value="hourly" selected={@aggregation == "hourly"}>Hourly</option>
              <option value="daily" selected={@aggregation == "daily"}>Daily</option>
            </select>

            <label for="chart_type">Select Chart Type:</label>
            <select name="chart_type" id="chart_type" class="border no-round max large">
              <option value="line" selected={@chart_type == "line"}>Line</option>
              <option value="scatter" selected={@chart_type == "scatter"}>Scatter</option>
            </select>

            <br />
            <button class="btn primary">
              Submit
            </button>
          </form>
        </div>
      <% else %>
        <article class="border medium no-padding middle-align center-align">
          <div class="padding">
            <h1>OR</h1>
          </div>
        </article>
      <% end %>

      <br />
      <nav class="no-space">
        <%= if @show_demo_button do %>
          <div class="demo-btn-container">
            <button class="border left-round right-round max fill large" phx-click="generate_demo">
              <span>Generate Demo Data</span>
            </button>
          </div>
        <% else %>
          <button class="border left-round max large" phx-click={JS.dispatch("removedata")}>
            <span>Remove Data</span>
          </button>
          <button
            class="border no-round max fill large"
            phx-click={JS.dispatch("adddata", detail: build_chart_params(assigns))}
          >
            <span>Add Data</span>
          </button>
          <button phx-click="delete_all_data" class="border right-round max fill large">
            <span> Delete All Entries</span>
          </button>
        <% end %>
      </nav>

      <br />
      <br />

      <.live_component
        module={FileUploadStockAppWeb.PageLive.ChartComponent}
        chart_data={@chart_data}
        chart_type={@chart_type}
        chart_options={@chart_options}
        id="chart_data"
      />
    </div>
    """
  end

  defp build_chart_params(assigns) do
    %{
      type: assigns.chart_type,
      chartData: assigns.chart_data,
      chartOptions: assigns.chart_options
    }
    |> Jason.encode!()
  end
end
