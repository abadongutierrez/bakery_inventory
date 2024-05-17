defmodule BakeryInventoryWeb.AlertHTML do
  use BakeryInventoryWeb, :html

  embed_templates "alert_html/*"

  @doc """
  Renders a alert form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def alert_form(assigns)
end
