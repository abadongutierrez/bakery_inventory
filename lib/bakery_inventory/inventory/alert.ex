defmodule BakeryInventory.Inventory.Alert do
  use Ecto.Schema
  import Ecto.Changeset

  schema "alerts" do
    field :message, :string
    field :status, :string
    belongs_to :item, BakeryInventory.Inventory.Item

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(alert, attrs) do
    alert
    |> cast(attrs, [:message, :status, :item_id])
    |> validate_required([:message, :status, :item_id])
  end
end
