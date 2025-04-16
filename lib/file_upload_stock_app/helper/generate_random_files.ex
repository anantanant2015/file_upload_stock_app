defmodule FileUploadStockApp.GenerateRandomFiles do
  @stock_symbols ["AAPL", "GOOG", "AMZN"]
  @num_rows 1000

  def generate_files do
    for symbol <- @stock_symbols do
      generate_file(symbol)
    end
  end

  defp generate_file(symbol) do
    file_name = "#{symbol}_data.tsv"
    file_path = Path.join("uploads", file_name)

    File.open!(file_path, [:write])
    |> write_rows(symbol)
  end

  defp write_rows(file, symbol) do
    for _ <- 1..@num_rows do
      timestamp = :rand.uniform(1_000_000_000)
      price = :rand.uniform(1000) |> Kernel./(1)
      row = "#{symbol}\t#{timestamp}\t#{price}\n"
      IO.binwrite(file, row)
    end

    File.close(file)
  end
end
