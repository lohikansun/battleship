require IEx
defmodule Battleship.Game do
  alias Battleship.Player
  def new(player) do
    %{
      started: false,
      accepted: false,
      player1: Player.new(player),
      player2: %{}
    }
end
  def player_game_state(game, player_name) do
    player = nil
    if (game.player1.name == player_name) do
      player = game.player1
    else
      player = game.player2
    end
    %{
      started: game.started,
      hits: player.hits,
      misses: player.misses,
      ships_to_place: player.ships_to_place,
      ships: player.ships,
      accepted: game.accepted
    }
  end

  def add_player(game, player) do
    Map.put(game, :player2, Player.new(player))
  end

  def accept(game) do
    Map.put(game, :accepted, true)
  end

  def other_name(game, player) do
    other = ""
    if (game.player1.name == player) do
      other = game.player2.name
    else
      other = game.player1.name
    end
  end
end
