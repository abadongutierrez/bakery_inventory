defmodule BakeryInventory.InventoryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BakeryInventory.Inventory` context.
  """

  alias BakeryInventory.Repo

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        price: "120.5",
        quantity: 42
      })
      |> BakeryInventory.Inventory.create_item()

    item
  end

  @doc """
  Generate a alert.
  """
  def alert_fixture(attrs \\ %{}) do
    # Ensure an item is created before creating an alert
    item = item_fixture()

    attrs = Map.put(attrs, :item_id, item.id)

    {:ok, alert} =
      attrs
      |> Enum.into(%{message: "some message", status: "some status", item_id: item.id})
      |> BakeryInventory.Inventory.create_alert()

    Repo.preload(alert, :item)
  end
end
