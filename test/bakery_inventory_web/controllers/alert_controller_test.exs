defmodule BakeryInventoryWeb.AlertControllerTest do
  use BakeryInventoryWeb.ConnCase

  import BakeryInventory.InventoryFixtures

  @create_attrs %{message: "some message", status: "some status"}
  @update_attrs %{message: "some updated message", status: "some updated status"}
  @invalid_attrs %{message: nil, status: nil}

  describe "index" do
    test "lists all alerts", %{conn: conn} do
      conn = get(conn, ~p"/alerts")
      assert html_response(conn, 200) =~ "Listing Alerts"
    end
  end

  describe "new alert" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/alerts/new")
      assert html_response(conn, 200) =~ "New Alert"
    end
  end

  describe "create alert" do
    setup %{conn: conn} do
      item = BakeryInventory.InventoryFixtures.item_fixture()
      {:ok, conn: conn, item: item}
    end

    test "redirects to show when data is valid", %{conn: conn, item: item} do
      conn = post(conn, ~p"/alerts", alert: Map.put(@create_attrs, :item_id, item.id))

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/alerts/#{id}"

      conn = get(conn, ~p"/alerts/#{id}")
      assert html_response(conn, 200) =~ "Alert #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/alerts", alert: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Alert"
    end
  end

  describe "edit alert" do
    setup [:create_alert]

    test "renders form for editing chosen alert", %{conn: conn, alert: alert} do
      conn = get(conn, ~p"/alerts/#{alert}/edit")
      assert html_response(conn, 200) =~ "Edit Alert"
    end
  end

  describe "update alert" do
    setup [:create_alert]

    test "redirects when data is valid", %{conn: conn, alert: alert} do
      conn = put(conn, ~p"/alerts/#{alert}", alert: @update_attrs)
      assert redirected_to(conn) == ~p"/alerts/#{alert}"

      conn = get(conn, ~p"/alerts/#{alert}")
      assert html_response(conn, 200) =~ "some updated message"
    end

    test "renders errors when data is invalid", %{conn: conn, alert: alert} do
      conn = put(conn, ~p"/alerts/#{alert}", alert: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Alert"
    end
  end

  describe "delete alert" do
    setup [:create_alert]

    test "deletes chosen alert", %{conn: conn, alert: alert} do
      conn = delete(conn, ~p"/alerts/#{alert}")
      assert redirected_to(conn) == ~p"/alerts"

      assert_error_sent 404, fn ->
        get(conn, ~p"/alerts/#{alert}")
      end
    end
  end

  defp create_alert(_) do
    alert = alert_fixture()
    %{alert: alert}
  end

  describe "acknowledge alert" do
    setup [:create_alert]
    test "updates alert status to acknowledged", %{conn: conn, alert: alert} do
      conn = put(conn, ~p"/alerts/#{alert}/acknowledge")
      assert redirected_to(conn) == ~p"/alerts"
      conn = get(conn, ~p"/alerts/#{alert}")
      assert html_response(conn, 200) =~ "acknowledged"
    end
  end
end
