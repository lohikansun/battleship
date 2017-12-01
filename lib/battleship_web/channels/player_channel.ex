defmodule BattleshipWeb.PlayerChannel do
  use BattleshipWeb, :channel
  alias Battleship.GameAgent
  
  def join("player:" <> name, payload, socket) do
    if authorized?(payload) do
      # Game agent logic  Modeled after NatTuck hangman application
      game = GameAgent.get(name) || Game.new()
      GameAgent.put(name, game)
      socket = socket
      |> assign(:name, name)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (player:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
