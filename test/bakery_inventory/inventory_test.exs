defmodule BakeryInventory.InventoryTest do
  use BakeryInventory.DataCase

  alias BakeryInventory.Inventory

  describe "items" do
    alias BakeryInventory.Inventory.Item

    import BakeryInventory.InventoryFixtures

    @invalid_attrs %{name: nil, description: nil, quantity: nil, price: nil}

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Inventory.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Inventory.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      valid_attrs = %{name: "some name", description: "some description", quantity: 42, price: "120.5"}

      assert {:ok, %Item{} = item} = Inventory.create_item(valid_attrs)
      assert item.name == "some name"
      assert item.description == "some description"
      assert item.quantity == 42
      assert item.price == Decimal.new("120.5")
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inventory.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description", quantity: 43, price: "456.7"}

      assert {:ok, %Item{} = item} = Inventory.update_item(item, update_attrs)
      assert item.name == "some updated name"
      assert item.description == "some updated description"
      assert item.quantity == 43
      assert item.price == Decimal.new("456.7")
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Inventory.update_item(item, @invalid_attrs)
      assert item == Inventory.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Inventory.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Inventory.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Inventory.change_item(item)
    end
  end

  describe "alerts" do
    alias BakeryInventory.Inventory.Alert

    import BakeryInventory.InventoryFixtures

    @invalid_attrs %{message: nil, status: nil}

    test "list_alerts/0 returns all alerts" do
      alert = alert_fixture()
      assert Inventory.list_alerts() == [alert]
    end

    test "get_alert!/1 returns the alert with given id" do
      alert = alert_fixture()
      assert Inventory.get_alert!(alert.id) == alert
    end

    test "create_alert/1 with valid data creates a alert" do
      valid_attrs = %{message: "some message", status: "some status"}

      assert {:ok, %Alert{} = alert} = Inventory.create_alert(valid_attrs)
      assert alert.message == "some message"
      assert alert.status == "some status"
    end

    test "create_alert/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inventory.create_alert(@invalid_attrs)
    end

    test "update_alert/2 with valid data updates the alert" do
      alert = alert_fixture()
      update_attrs = %{message: "some updated message", status: "some updated status"}

      assert {:ok, %Alert{} = alert} = Inventory.update_alert(alert, update_attrs)
      assert alert.message == "some updated message"
      assert alert.status == "some updated status"
    end

    test "update_alert/2 with invalid data returns error changeset" do
      alert = alert_fixture()
      assert {:error, %Ecto.Changeset{}} = Inventory.update_alert(alert, @invalid_attrs)
      assert alert == Inventory.get_alert!(alert.id)
    end

    test "delete_alert/1 deletes the alert" do
      alert = alert_fixture()
      assert {:ok, %Alert{}} = Inventory.delete_alert(alert)
      assert_raise Ecto.NoResultsError, fn -> Inventory.get_alert!(alert.id) end
    end

    test "change_alert/1 returns a alert changeset" do
      alert = alert_fixture()
      assert %Ecto.Changeset{} = Inventory.change_alert(alert)
    end
  end
end
