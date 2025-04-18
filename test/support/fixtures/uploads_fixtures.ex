defmodule FileUploadStockApp.UploadsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FileUploadStockApp.Uploads` context.
  """

  @doc """
  Generate a data.
  """
  def data_fixture(attrs \\ %{}) do
    :ok =
      attrs
      |> Enum.into(%{
        file: "some file",
        status: "some status"
      })
      |> FileUploadStockApp.DataQuery.insert_data()
  end
end
