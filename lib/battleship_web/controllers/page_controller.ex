defmodule BattleshipWeb.PageController do
  use BattleshipWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def name(conn, %{"name" => name}) do
    conn
    |> put_session(:user, name)
    |> put_flash(:info, "Welcome #{name}")
    |> redirect(to: page_path(conn, :index))
  end

  def table(conn, %{"table" => table}) do
    conn
    |> put_session(:table, table)
    |> put_flash(:info, "Joined Table #{table}")
    |> redirect(to: page_path(conn, :index))
  end
end
