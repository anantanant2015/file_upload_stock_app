defmodule FileUploadStockApp.DataQueryTest do
  use FileUploadStockApp.DataCase, async: true
  alias FileUploadStockApp.DataQuery
  alias FileUploadStockApp.Data

  describe "list_unique_symbols/0" do
    test "returns unique symbols from the database" do
      # Insert test data
      Repo.insert!(%Data{symbol: "AAPL", timestamp: DateTime.utc_now(), price: 100})
      Repo.insert!(%Data{symbol: "GOOG", timestamp: DateTime.utc_now(), price: 200})
      Repo.insert!(%Data{symbol: "AAPL", timestamp: DateTime.utc_now(), price: 150})

      # Call the function
      symbols = DataQuery.list_unique_symbols()

      # Check that only unique symbols are returned
      assert symbols == ["AAPL", "GOOG"]
    end
  end

  describe "delete_all_data/0" do
    test "deletes all data from the database" do
      # Insert test data
      Repo.insert!(%Data{symbol: "AAPL", timestamp: DateTime.utc_now(), price: 100})
      Repo.insert!(%Data{symbol: "GOOG", timestamp: DateTime.utc_now(), price: 200})

      # Call the delete function
      DataQuery.delete_all_data()

      # Verify no data exists
      assert Repo.all(Data) == []
    end
  end

  describe "fetch_aggregated_data/2" do
    test "fetches hourly aggregated data" do
      # Insert test data
      timestamp = DateTime.utc_now() |> DateTime.to_unix()
      Repo.insert!(%Data{symbol: "AAPL", timestamp: timestamp, price: 100})
      Repo.insert!(%Data{symbol: "AAPL", timestamp: timestamp + 3600, price: 150})

      # Fetch aggregated data for hourly
      data = DataQuery.fetch_aggregated_data("AAPL", :hourly)

      # Ensure the data is aggregated correctly
      assert length(data) == 1
      assert data |> hd() |> Map.get(:avg_price) == 125
    end

    test "fetches daily aggregated data" do
      # Insert test data
      timestamp = DateTime.utc_now() |> DateTime.to_unix()
      Repo.insert!(%Data{symbol: "AAPL", timestamp: timestamp, price: 100})
      Repo.insert!(%Data{symbol: "AAPL", timestamp: timestamp + 86400, price: 200})

      # Fetch aggregated data for daily
      data = DataQuery.fetch_aggregated_data("AAPL", :daily)

      # Ensure the data is aggregated correctly
      assert length(data) == 1
      assert data |> hd() |> Map.get(:avg_price) == 150
    end
  end

  describe "insert_data/1" do
    test "inserts data into the database successfully" do
      file_data = [
        %{symbol: "AAPL", timestamp: DateTime.utc_now(), price: 100},
        %{symbol: "GOOG", timestamp: DateTime.utc_now(), price: 200}
      ]

      # Insert data and check return
      result = DataQuery.insert_data(file_data)

      # Check that data was inserted correctly
      assert result == :ok
      assert Repo.all(Data) |> length() == 2
    end

    test "handles error when inserting invalid data" do
      # Insert invalid data (e.g., missing fields)
      file_data = [%{symbol: "AAPL", timestamp: DateTime.utc_now()}]  # Missing price

      result = DataQuery.insert_data(file_data)

      # Ensure the function handles the error gracefully
      assert result == :error
    end
  end

  describe "has_data?/0" do
    test "returns true if there is data in the database" do
      # Insert test data
      Repo.insert!(%Data{symbol: "AAPL", timestamp: DateTime.utc_now(), price: 100})

      # Check if data exists
      assert DataQuery.has_data?() == true
    end

    test "returns false if there is no data in the database" do
      # Ensure no data is in the database
      Repo.delete_all(Data)

      # Check if data exists
      assert DataQuery.has_data?() == false
    end
  end

  describe "generate_demo_data/0" do
    test "generates and inserts demo data for 7 days" do
      # Check initial data count
      initial_count = Repo.aggregate(Data, :count, :id)

      # Call generate demo data function
      DataQuery.generate_demo_data()

      # Ensure that new data has been inserted
      new_count = Repo.aggregate(Data, :count, :id)
      assert new_count > initial_count
    end
  end
end
