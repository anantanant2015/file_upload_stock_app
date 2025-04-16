defmodule FileUploadStockApp.Workers.ProcessFile do
  use Oban.Worker, queue: :default, max_attempts: 3

  alias FileUploadStockApp.Repo
  alias FileUploadStockApp.Data

  @batch_size 500

  def perform(%Oban.Job{args: %{"file_path" => file_path}}) do
    file_data = File.read!(file_path)
                      |> String.split("\n")
                      |> Enum.map(&parse_line/1)

    insert_data(file_data)
  end

  defp parse_line(line) do
    [symbol, timestamp, price] = String.split(line, "\t")
    %{symbol: symbol, timestamp: String.to_integer(timestamp), price: String.to_float(price)}
  end

  defp insert_data(file_data) do
    file_data
    |> Enum.chunk_every(@batch_size)
    |> Enum.each(&Repo.insert_all(Data, &1))
  end
end
