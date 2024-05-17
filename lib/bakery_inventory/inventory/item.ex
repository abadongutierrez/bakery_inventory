defmodule BakeryInventory.Inventory.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :name, :string
    field :description, :string
    field :quantity, :integer
    field :price, :decimal

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :description, :quantity, :price])
    |> validate_required([:name, :description, :quantity, :price])
  end
end
