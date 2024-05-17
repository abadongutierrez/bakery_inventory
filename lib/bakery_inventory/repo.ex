defmodule BakeryInventory.Repo do
  use Ecto.Repo,
    otp_app: :bakery_inventory,
    adapter: Ecto.Adapters.Postgres
end
