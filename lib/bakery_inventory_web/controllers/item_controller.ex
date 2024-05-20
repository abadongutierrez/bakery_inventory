defmodule BakeryInventoryWeb.ItemController do
  use BakeryInventoryWeb, :controller

  alias BakeryInventory.Inventory
  alias BakeryInventory.Inventory.Item

  def index(conn, _params) do
    items = Inventory.list_items()
    total_count = Inventory.count_items()
    pending_alerts = Inventory.count_pending_alerts()
    render(conn, :index, items: items, total_count: total_count, pending_alerts: pending_alerts)
  end

  def new(conn, _params) do
    changeset = Inventory.change_item(%Item{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"item" => item_params}) do
    case Inventory.create_item(item_params) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item created successfully.")
        |> redirect(to: ~p"/items/#{item}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    item = Inventory.get_item!(id)
    render(conn, :show, item: item)
  end

  def edit(conn, %{"id" => id}) do
    item = Inventory.get_item!(id)
    changeset = Inventory.change_item(item)
    render(conn, :edit, item: item, changeset: changeset)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = Inventory.get_item!(id)

    case Inventory.update_item_and_check_alert(item, item_params) do
      {:ok, item, msg} ->
        conn
        |> put_flash(:info, "Item updated successfully. " <> msg <> ".")
        |> redirect(to: ~p"/items/#{item}")
      {:error, changeset} ->
        render(conn, :edit, item: item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Inventory.get_item!(id)
    {:ok, _item} = Inventory.delete_item(item)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: ~p"/items")
  end

  def search(conn, %{"query" => query}) do
    items = Inventory.search_items(query)
    total_count = Inventory.count_items()
    pending_alerts = Inventory.count_pending_alerts()
    render(conn, :index, items: items, total_count: total_count, query: query, pending_alerts: pending_alerts)
  end
end
