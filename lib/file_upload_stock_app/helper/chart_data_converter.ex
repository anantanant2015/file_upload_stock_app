defmodule FileUploadStockApp.ChartDataConverter do
  def to_chart_data(data, opts \\ %{}) do
    chart_type = Map.get(opts, :chart_type, "line")
    label = Map.get(opts, :label, "Average Price")

    case chart_type do
      "scatter" ->
        formatted_data =
          Enum.map(data, fn %{timestamp: timestamp, avg_price: avg_price} ->
            # Attempt to parse hour into a float or timestamp if needed
            %{x: hour_to_x(timestamp), y: avg_price}
          end)

        %{
          type: "scatter",
          data: %{
            datasets: [
              %{
                label: label,
                data: formatted_data,
                backgroundColor: "rgb(255, 99, 132)"
              }
            ]
          },
          options: %{
            scales: %{
              x: %{
                type: "linear",
                position: "bottom"
              }
            }
          }
        }

      "line" ->
        %{
          type: "line",
          data: %{
            labels: Enum.map(data, & &1.timestamp),
            datasets: [
              %{
                label: label,
                data: Enum.map(data, & &1.avg_price),
                borderWidth: 1
              }
            ]
          },
          options: %{
            scales: %{
              y: %{
                beginAtZero: true
              }
            }
          }
        }

      _ ->
        raise ArgumentError, "Unsupported chart type: #{chart_type}"
    end
  end

  # Converts hour (ISO string) to a float timestamp or index (can be customized)
  defp hour_to_x(hour) when is_binary(hour) do
    # Here we simply return index of hour in a sorted list (for demo purposes)
    # Customize this to convert to Unix timestamp or numerical value if needed
    case NaiveDateTime.from_iso8601(hour) do
      {:ok, naive} ->
        # Convert to UNIX timestamp (float)
        naive
        |> NaiveDateTime.to_erl()
        |> :calendar.datetime_to_gregorian_seconds()
        |> Kernel.-(:calendar.datetime_to_gregorian_seconds({{1970, 1, 1}, {0, 0, 0}}))
        |> Kernel./(1)

      _ ->
        0
    end
  end
end
