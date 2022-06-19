defmodule WebshopRestaurantWeb.LayoutView do
  use WebshopRestaurantWeb, :view

  def new_locale(conn, locale, language_title) do
    "<a href=\"#{Routes.page_path(conn, :index, locale: locale)}\">#{language_title}</a>" |> raw
  end
end
