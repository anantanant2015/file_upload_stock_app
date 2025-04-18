defmodule FileUploadStockAppWeb.PageLiveTest do
  use FileUploadStockAppWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  alias FileUploadStockApp.DataQuery

  describe "initial mount" do
    test "renders demo button if no data", %{conn: conn} do
      DataQuery.delete_all_data()
      {:ok, view, _html} = live(conn, "/")
      assert has_element?(view, "button", "Generate Demo Data")
    end

    test "renders chart form if data is present", %{conn: conn} do
      # Insert mock data first
      FileUploadStockApp.GenerateRandomFiles.generate_files()
      |> Enum.flat_map(&FileUploadStockApp.FileUtils.parse_tsv/1)
      |> then(&DataQuery.insert_data/1)

      {:ok, view, _html} = live(conn, "/")
      assert has_element?(view, "form")
    end
  end

  describe "generate_demo event" do
    test "sends uploaded paths and redirects", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      render_click(view, :generate_demo)
    end
  end

  describe "delete_all_data event" do
    test "clears the DB and redirects", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      render_click(view, :delete_all_data)
      assert DataQuery.has_data?() == false
    end
  end

  describe "upload event" do
    test "uploads a valid file", %{conn: _conn} do
      # You'll need to simulate upload if you're testing file upload directly
      # Or move that logic to a component and test it separately
    end
  end

  describe "update_chart event" do
    test "updates assigns and triggers JS chart render", %{conn: conn} do
      # Insert sample data
      FileUploadStockApp.GenerateRandomFiles.generate_files()
      |> Enum.flat_map(&FileUploadStockApp.FileUtils.parse_tsv/1)
      |> then(&DataQuery.insert_data/1)

      {:ok, view, _html} = live(conn, "/")

      [symbol | _] = DataQuery.list_unique_symbols()

      render_submit(view, "update_chart", %{
        "symbol" => symbol,
        "aggregation" => "hourly",
        "chart_type" => "scatter"
      })

      # Check assign was updated
      assert render(view) =~ symbol
    end
  end
end
