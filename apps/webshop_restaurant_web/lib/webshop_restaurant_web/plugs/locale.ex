defmodule WebshopRestaurantWeb.Plugs.Locale do
  # Let this module know it is a plug
  import Plug.Conn

  # One time retrieve the locales from the config file and store it in a @locales variable.
  @locales Gettext.known_locales(WebshopRestaurantWeb.Gettext)

  def init(default), do: default

  def call(conn, _options) do
    case fetch_locale_from(conn) do
      nil ->
        # No locale is set or found in the cookies
        conn

      # A locale is set of found in the cookies, change the locale to the prefered langage and place a new cookie
      locale ->
        WebshopRestaurantWeb.Gettext |> Gettext.put_locale(locale)
        # Put a locale cookie in the response.
        conn |> put_resp_cookie("locale", locale, max_age: 365 * 24 * 60 * 60)
    end
  end

  defp fetch_locale_from(conn) do
    (conn.params["locale"] || conn.cookies["locale"])
    |> check_locale
  end

  defp check_locale(locale) when locale in @locales, do: locale
  defp check_locale(_), do: nil
end
