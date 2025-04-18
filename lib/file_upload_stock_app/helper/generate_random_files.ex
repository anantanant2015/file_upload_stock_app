defmodule FileUploadStockApp.GenerateRandomFiles do
  @stock_symbols ["AAPL", "GOOG", "AMZN"]
  @num_rows 1000
  @uploads_dir "uploads"

  def generate_files do
    # Ensure the uploads directory exists
    create_uploads_directory()

    # Generate files for each stock symbol
    for symbol <- @stock_symbols do
      generate_file(symbol)
    end
  end

  defp create_uploads_directory do
    # Check if the directory exists, if not create it
    unless File.exists?(@uploads_dir) do
      case File.mkdir_p(@uploads_dir) do
        :ok -> IO.puts("Created uploads directory.")
        {:error, reason} -> IO.puts("Failed to create uploads directory: #{reason}")
      end
    end
  end

  defp generate_file(symbol) do
    # Construct the file path based on symbol
    file_name = "#{symbol}_data.tsv"
    file_path = Path.join(@uploads_dir, file_name)

    # Open the file for writing, ensure we handle any potential errors
    {:ok, file} = File.open(file_path, [:write])

    # Write rows to the file
    write_rows(file, symbol)

    # Close the file after writing
    File.close(file)

    IO.puts("Generated file: #{file_path}")
    file_path
  end

  defp write_rows(file, symbol) do
    for _ <- 1..@num_rows do
      # Generate a random timestamp between 1 and 1 billion (representing Unix time)
      timestamp = :rand.uniform(1_000_000_000)

      # Generate a random price between 0 and 1000
      price = :rand.uniform(1000) |> Kernel./(1)

      # Create a tab-separated row for each entry
      row = "#{symbol}\t#{timestamp}\t#{price}\n"

      # Write the row to the file
      IO.binwrite(file, row)
    end
  end
end
