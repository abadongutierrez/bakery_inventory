defmodule BakeryInventory.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BakeryInventoryWeb.Telemetry,
      BakeryInventory.Repo,
      {DNSCluster, query: Application.get_env(:bakery_inventory, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BakeryInventory.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: BakeryInventory.Finch},
      # Start a worker by calling: BakeryInventory.Worker.start_link(arg)
      # {BakeryInventory.Worker, arg},
      # Start to serve requests, typically the last entry
      BakeryInventoryWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BakeryInventory.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BakeryInventoryWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
