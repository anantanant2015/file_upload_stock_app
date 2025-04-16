defmodule FileUploadStockApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FileUploadStockAppWeb.Telemetry,
      FileUploadStockApp.Repo,
      {DNSCluster, query: Application.get_env(:file_upload_stock_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FileUploadStockApp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FileUploadStockApp.Finch},
      # Start a worker by calling: FileUploadStockApp.Worker.start_link(arg)
      # {FileUploadStockApp.Worker, arg},
      # Start to serve requests, typically the last entry
      FileUploadStockAppWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FileUploadStockApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FileUploadStockAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
