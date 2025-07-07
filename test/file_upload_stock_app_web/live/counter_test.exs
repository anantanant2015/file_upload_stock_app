defmodule FileUploadStockAppWeb.CounterTest do
  use FileUploadStockAppWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  describe "LiveView + Component Counter Integration" do
    test "child increments but parent doesn't know until get_value is clicked", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/counter")

      # Click increment
      view |> element("button", "Increment") |> render_click()

      # Parent should not have updated yet
      html = render(view)
      assert html =~ "<p><strong>Value from Child:</strong> Not yet fetched</p>"
    end

    test "parent fetches child's count when get_value is clicked", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/counter")

      view |> element("button", "Increment") |> render_click()
      view |> element("button", "Increment") |> render_click()

      view |> element("button", "Get Value from Child") |> render_click()
      Process.sleep(100) # small wait for event to complete

      html = render(view)
      assert html =~ "<p><strong>Value from Child:</strong> 2</p>"
    end

    test "reset clears both parent and child states", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/counter")

      view |> element("button", "Increment") |> render_click()
      view |> element("button", "Get Value from Child") |> render_click()

      html = render(view)
      assert html =~ "<p><strong>Value from Child:</strong> 1</p>"

      view |> element("button", "Reset Both") |> render_click()
      Process.sleep(100)

      html = render(view)
      assert html =~ "<p><strong>Value from Child:</strong> 0</p>"
      assert html =~ "<p>Counter: 0</p>"
    end
  end
end
