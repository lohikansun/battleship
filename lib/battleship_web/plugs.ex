defmodule BattleshipWeb.Plugs do
  import Plug.Conn

  def fetch_user(conn, _opts) do
    user = get_session(conn, :user)
    if user do
      token = Phoenix.Token.sign(BattleshipWeb.Endpoint, "user", user)
      conn
      |> assign(:user_name, user)
      |> assign(:user_token, token)


    else
      conn
      |> assign(:user_name, nil)
      |> assign(:user_token, nil)
    end
  end

  def fetch_table(conn, _opts) do
    table = get_session(conn, :table)
    if table do
      conn
      |> assign(:table_name, table)


    else
      conn
      |> assign(:table_name, nil)
    end
  end

end
