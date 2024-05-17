defmodule BakeryInventory.InventoryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BakeryInventory.Inventory` context.
  """

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
    {:ok, alert} =
      attrs
      |> Enum.into(%{
        message: "some message",
        status: "some status"
      })
      |> BakeryInventory.Inventory.create_alert()

    alert
  end
end
