defmodule BattleshipWeb.Router do
  use BattleshipWeb, :router
  import BattleshipWeb.Plugs

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_user
    plug :fetch_table
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BattleshipWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/table", PageController, :table
    post "/name", PageController, :name
  end

  # Other scopes may use custom stacks.
  # scope "/api", BattleshipWeb do
  #   pipe_through :api
  # end
end
