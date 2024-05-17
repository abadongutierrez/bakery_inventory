defmodule BakeryInventory.Repo.Migrations.CreateAlerts do
  use Ecto.Migration

  def change do
    create table(:alerts) do
      add :message, :string
      add :status, :string
      add :item_id, references(:items, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:alerts, [:item_id])
  end
end
