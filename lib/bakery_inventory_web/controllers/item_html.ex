defmodule BakeryInventoryWeb.ItemHTML do
  use BakeryInventoryWeb, :html

  embed_templates "item_html/*"

  @doc """
  Renders a item form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def item_form(assigns)

  def format_price(price) do
    formattedPrice = price
    |> Decimal.round(2)
    |> Decimal.to_string(:normal)
    |> String.split(".")
    |> case do
      [integer, fraction] -> integer <> "." <> String.pad_trailing(fraction, 2, "0")
      [integer] -> integer <> ".00"
    end
    "$" <> formattedPrice
  end
end
