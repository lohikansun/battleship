require IEx
defmodule Battleship.Game do
  alias Battleship.Player
  def new(player) do
    %{
      started: false,
      accepted: false,
      player1: Player.new(player),
      player2: Player.new("fake")
    }
end
  def player_game_state(game, player_name) do
    you = nil
    them = nil
    if (game.player1.name == player_name) do
      you = game.player1
      them = game.player2
    else
      you = game.player2
      them = game.player1
    end
    %{
      started: game.started,
      your_hits: you.hits,
      your_misses: you.misses,
      their_hits: them.hits,
      their_misses: them.misses,
      ships_to_place: you.ships_to_place,
      ships: you.ships,
      accepted: game.accepted,
      horizontal: you.horizontal
    }
  end

  def add_player(game, player) do
    Map.put(game, :player2, Player.new(player))
  end

  def accept(game) do
    Map.put(game, :accepted, true)
  end

  def rotate(game, player_name) do
    player = nil
    key = nil
    if (game.player1.name == player_name) do
      player = game.player1
      key = :player1
    else
      player = game.player2
      key = :player2
    end
    IEx.pry
    player = Map.put(player, :horizontal, not player.horizontal)
    Map.put(game, key, player)
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
