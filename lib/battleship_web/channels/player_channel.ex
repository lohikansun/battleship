require IEx
defmodule BattleshipWeb.PlayerChannel do
  use BattleshipWeb, :channel
  alias Battleship.Agent
  alias Battleship.Game

  def join("player:" <> name, payload, socket) do
    if authorized?(payload) do
      gameName = payload <> "Game"
      # Game agent logic  Modeled after NatTuck hangman application
      game = Agent.get(gameName)
      if game do
        game = Game.add_player(game, name)
      else
        game = Game.new(name)
      end
      Agent.put(gameName, game)
      socket = socket
      |> assign(:gameName, gameName)
      |> assign(:player, name)
      {:ok, Game.player_game_state(game, name), socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("accept", payload, socket) do
    gameName = socket.assigns[:gameName]
    player = socket.assigns[:player]
    game = Agent.get(gameName)
    other = Game.other_name(game, player)
    game = Game.accept(game)
    Agent.put(gameName, game)
    BattleshipWeb.Endpoint.broadcast! "player:" <> other, "start", Game.player_game_state(game, other)
    #broadcast socket, "test", %{}
    {:reply, {:ok, Game.player_game_state(game, player)}, socket}
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
