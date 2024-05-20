defmodule BakeryInventoryWeb.ItemControllerTest do
  use BakeryInventoryWeb.ConnCase

  import BakeryInventory.InventoryFixtures

  @create_attrs %{name: "some name", description: "some description", quantity: 42, price: "120.5"}
  @update_attrs %{name: "some updated name", description: "some updated description", quantity: 43, price: "456.7"}
  @invalid_attrs %{name: nil, description: nil, quantity: nil, price: nil}

  describe "index" do
    test "lists all items", %{conn: conn} do
      conn = get(conn, ~p"/items")
      assert html_response(conn, 200) =~ "Listing Items"
    end
  end

  describe "new item" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/items/new")
      assert html_response(conn, 200) =~ "New Item"
    end
  end

  describe "create item" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/items", item: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/items/#{id}"

      conn = get(conn, ~p"/items/#{id}")
      assert html_response(conn, 200) =~ "Item #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/items", item: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Item"
    end
  end

  describe "edit item" do
    setup [:create_item]

    test "renders form for editing chosen item", %{conn: conn, item: item} do
      conn = get(conn, ~p"/items/#{item}/edit")
      assert html_response(conn, 200) =~ "Edit Item"
    end
  end

  describe "update item" do
    setup [:create_item]

    test "redirects when data is valid", %{conn: conn, item: item} do
      conn = put(conn, ~p"/items/#{item}", item: @update_attrs)
      assert redirected_to(conn) == ~p"/items/#{item}"

      conn = get(conn, ~p"/items/#{item}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, item: item} do
      conn = put(conn, ~p"/items/#{item}", item: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Item"
    end
  end

  describe "delete item" do
    setup [:create_item]

    test "deletes chosen item", %{conn: conn, item: item} do
      conn = delete(conn, ~p"/items/#{item}")
      assert redirected_to(conn) == ~p"/items"

      assert_error_sent 404, fn ->
        get(conn, ~p"/items/#{item}")
      end
    end
  end

  defp create_item(_) do
    item = item_fixture()
    %{item: item}
  end

  describe "search item" do
    setup [:create_item]

    test "returns matching items with name", %{conn: conn, item: item} do
      conn = get(conn, "/items/search", %{query: "some name"})
      assert html_response(conn, 200) =~ "Listing Items"
      assert html_response(conn, 200) =~ item.name
    end

    test "returns matching items with description", %{conn: conn, item: item} do
      conn = get(conn, "/items/search", %{query: "some description"})
      assert html_response(conn, 200) =~ "Listing Items"
      assert html_response(conn, 200) =~ item.description
    end

    test "returns no results for non-existing item", %{conn: conn} do
      conn = get(conn, "/items/search", %{query: "non-existing item"})
      assert html_response(conn, 200) =~ "Listing Items"
      assert html_response(conn, 200) =~ "No items found"
    end
  end
end
