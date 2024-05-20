defmodule BakeryInventory.Inventory.AlertTest do
  use BakeryInventory.DataCase, async: true

  alias BakeryInventory.Inventory.Alert
  alias BakeryInventory.Inventory.Item

  describe "changeset/2" do
    setup do
      item = %Item{id: 1, name: "Test Item", description: "Test Description", quantity: 10, price: Decimal.new("10.5")}
      {:ok, item: item}
    end

    test "validates presence of required fields", %{item: item} do
      changeset = Alert.changeset(%Alert{}, %{message: "", status: "", item_id: item.id})

      assert %{message: ["can't be blank"], status: ["can't be blank"]} = errors_on(changeset)
    end

    test "creates a valid changeset with valid data", %{item: item} do
      changeset = Alert.changeset(%Alert{}, %{message: "Test Message", status: "Test Status", item_id: item.id})

      assert changeset.valid?
    end
  end
end
