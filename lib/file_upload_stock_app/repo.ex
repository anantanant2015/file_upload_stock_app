defmodule FileUploadStockApp.Repo do
  use Ecto.Repo,
    otp_app: :file_upload_stock_app,
    adapter: Ecto.Adapters.Postgres
end
