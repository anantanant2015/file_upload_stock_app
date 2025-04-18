defmodule FileUploadStockApp.FileUtils do
  @moduledoc """
  Utility module to handle TSV file saving and parsing.
  """

  @upload_dir "uploads"

  def save_file(%Plug.Upload{path: tmp_path, filename: filename}) do
    dest = Path.join(@upload_dir, filename)
    File.cp!(tmp_path, dest)
    {:ok, dest}
  rescue
    _ -> :error
  end

  def parse_tsv(path) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    File.read!(path)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      [symbol, timestamp, price] = String.split(line, "\t")
      %{
        symbol: symbol,
        timestamp: String.to_integer(timestamp),
        price: String.to_float(price),
        inserted_at: now,
        updated_at: now
      }
    end)
    |> then(&(&1))
  rescue
    _ -> :error
  end
end
