defmodule BakeryInventoryWeb.AlertController do
  use BakeryInventoryWeb, :controller

  alias BakeryInventory.Inventory
  alias BakeryInventory.Inventory.Alert

  def index(conn, _params) do
    alerts = Inventory.list_alerts()
    render(conn, :index, alerts: alerts)
  end

  def new(conn, _params) do
    changeset = Inventory.change_alert(%Alert{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"alert" => alert_params}) do
    case Inventory.create_alert(alert_params) do
      {:ok, alert} ->
        conn
        |> put_flash(:info, "Alert created successfully.")
        |> redirect(to: ~p"/alerts/#{alert}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    alert = Inventory.get_alert!(id)
    render(conn, :show, alert: alert)
  end

  def edit(conn, %{"id" => id}) do
    alert = Inventory.get_alert!(id)
    changeset = Inventory.change_alert(alert)
    render(conn, :edit, alert: alert, changeset: changeset)
  end

  def update(conn, %{"id" => id, "alert" => alert_params}) do
    alert = Inventory.get_alert!(id)

    case Inventory.update_alert(alert, alert_params) do
      {:ok, alert} ->
        conn
        |> put_flash(:info, "Alert updated successfully.")
        |> redirect(to: ~p"/alerts/#{alert}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, alert: alert, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    alert = Inventory.get_alert!(id)
    {:ok, _alert} = Inventory.delete_alert(alert)

    conn
    |> put_flash(:info, "Alert deleted successfully.")
    |> redirect(to: ~p"/alerts")
  end

  def acknowledge(conn, %{"id" => id}) do
    alert = Inventory.get_alert!(id)
    {:ok, _alert} = Inventory.update_alert(alert, %{status: "acknowledged"})

    conn
    |> put_flash(:info, "Alert acknowledged.")
    |> redirect(to: ~p"/alerts")
  end
end
