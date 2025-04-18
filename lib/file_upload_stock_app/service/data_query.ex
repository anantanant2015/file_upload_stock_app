defmodule FileUploadStockApp.DataQuery do
  @moduledoc """
  Handles all database querying and insertion logic related to stock data.
  """

  import Ecto.Query
  alias FileUploadStockApp.{Repo, Data}

  def list_unique_symbols do
    Repo.all(from d in Data, select: d.symbol, distinct: true)
  end

  def delete_all_data do
    Repo.delete_all(Data)
  end

  def fetch_aggregated_data(symbol, :hourly) do
    Repo.all(
      from d in Data,
        where: d.symbol == ^symbol,
        group_by: fragment("date_trunc('hour', to_timestamp(?))", d.timestamp),
        select: %{
          timestamp: fragment("date_trunc('hour', to_timestamp(?))", d.timestamp),
          avg_price: avg(d.price)
        }
    )
  end

  def fetch_aggregated_data(symbol, :daily) do
    Repo.all(
      from d in Data,
        where: d.symbol == ^symbol,
        group_by: fragment("date_trunc('day', to_timestamp(?))", d.timestamp),
        select: %{
          timestamp: fragment("date_trunc('day', to_timestamp(?))", d.timestamp),
          avg_price: avg(d.price)
        }
    )
  end

  def insert_data(file_data) do
    Enum.chunk_every(file_data, 500)
    |> Enum.each(fn chunk -> Repo.insert_all(Data, chunk) end)

    :ok
  rescue
    e ->
      require Logger
      Logger.warning("Error inserting data: #{inspect(e)}")
      :error
  end

  def has_data? do
    FileUploadStockApp.Repo.exists?(from d in FileUploadStockApp.Data)
  end

  @doc """
Generates and inserts 7 days of hourly stock data for 3 fake symbols.
"""
def generate_demo_data do
  now = DateTime.utc_now() |> DateTime.to_unix()
  symbols = ["AAPL", "GOOG", "AMZN"]
  hours = Enum.to_list(0..(24 * 7 - 1))

  demo_data =
    for symbol <- symbols,
        hour <- hours do
      ts = now - hour * 3600
      %{
        symbol: symbol,
        timestamp: ts,
        price: :rand.uniform() * 1000 |> Float.round(2),
        inserted_at: NaiveDateTime.utc_now(),
        updated_at: NaiveDateTime.utc_now()
      }
    end

  insert_data(demo_data)
end


end
