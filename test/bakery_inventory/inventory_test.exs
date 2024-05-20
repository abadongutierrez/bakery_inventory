defmodule BakeryInventory.InventoryTest do
  use BakeryInventory.DataCase

  alias BakeryInventory.Inventory
  alias BakeryInventory.Inventory.Item
  alias BakeryInventory.Inventory.Alert
  import BakeryInventory.InventoryFixtures


  describe "items" do
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
      valid_attrs_item = %{name: "some name", description: "some description", quantity: 42, price: "120.5"}
      assert {:ok, %Item{} = item} = Inventory.create_item(valid_attrs_item)
      valid_attrs = %{message: "some message", status: "some status", item_id: item.id}

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
      alert = alert_fixture(%{item_id: 1})
      assert %Ecto.Changeset{} = Inventory.change_alert(alert)
    end
  end

  describe "update_item_and_check_alert/2" do
    test "updates the item and creates an alert when quantity is 0" do
      item = item_fixture(%{quantity: 10})
      update_attrs = %{quantity: 0}

      assert {:ok, updated, "There are alerts"} = Inventory.update_item_and_check_alert(item, update_attrs)
      assert updated.quantity == 0
      assert Inventory.get_alert_for_item(updated).message == "Item inventory is depleted"
    end

    test "updates the item and creates an alert when quantity is less than or equal to 5" do
      item = item_fixture(%{quantity: 10})
      update_attrs = %{quantity: 5}

      assert {:ok, updated, "There are alerts"} = Inventory.update_item_and_check_alert(item, update_attrs)
      assert updated.quantity == 5
      assert Inventory.get_alert_for_item(updated).message == "Item inventory is low"
    end

    test "returns error changeset when update data is invalid" do
      item = item_fixture()
      assert {:ok, _, ""} = Inventory.update_item_and_check_alert(item, @invalid_attrs)
    end
  end

  describe "search_items/1" do
    test "returns items matching the given search term" do
      item1 = item_fixture(%{name: "Apple Pie"})
      item2 = item_fixture(%{name: "Blueberry Muffin"})
      item3 = item_fixture(%{name: "Chocolate Cake"})

      assert Inventory.search_items("Apple") == [item1]
      assert Inventory.search_items("Muffin") == [item2]
      assert Inventory.search_items("Chocolate") == [item3]
      assert Inventory.search_items("Pie") == [item1]
      assert Inventory.search_items("Cake") == [item3]
      assert Inventory.search_items("Blueberry") == [item2]
    end

    test "returns items matching the given search term in description" do
      item1 = item_fixture(%{description: "Delicious apple pie"})
      item2 = item_fixture(%{description: "Fresh blueberry muffin"})
      item3 = item_fixture(%{description: "Decadent chocolate cake"})
      assert Inventory.search_items("Delicious") == [item1]
      assert Inventory.search_items("Fresh") == [item2]
      assert Inventory.search_items("Decadent") == [item3]
      assert Inventory.search_items("Apple") == [item1]
      assert Inventory.search_items("Muffin") == [item2]
      assert Inventory.search_items("Chocolate") == [item3]
    end
  end

  describe "create_item/1" do
    test "creates a new item with valid data" do
      attrs = %{name: "Apple Pie", description: "Desc", price: 10.0, quantity: 10}
      assert {:ok, %Item{} = item} = Inventory.create_item(attrs)
      assert item.name == "Apple Pie"
      assert item.quantity == 10
    end

    test "returns error changeset when data is invalid" do
      attrs = %{name: nil, quantity: 10}
      assert {:error, %Ecto.Changeset{}} = Inventory.create_item(attrs)
    end
  end

  describe "create_alert/1" do
    test "creates a new alert with valid data" do
      item = item_fixture(%{quantity: 0})
      attrs = %{message: "Item inventory is depleted", status: "pending", item_id: item.id}
      assert {:ok, %Alert{} = alert} = Inventory.create_alert(attrs)
      assert alert.message == "Item inventory is depleted"
      assert alert.status == "pending"
      assert alert.item_id == item.id
    end

    test "returns error changeset when data is invalid" do
      attrs = %{message: nil, status: "pending", item_id: nil}
      assert {:error, %Ecto.Changeset{}} = Inventory.create_alert(attrs)
    end
  end
end
