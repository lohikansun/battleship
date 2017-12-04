require IEx
defmodule Battleship.Game do
  alias Battleship.Player
  def new(player) do
    %{
      started: false,
      accepted: false,
      player1: Player.new(player),
      player2: Player.new("fake"),
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
      your_sunk: you.sunk,
      their_sunk: them.sunk,
      ships_to_place: you.ships_to_place,
      ships: you.ships,
      accepted: game.accepted,
      horizontal: you.horizontal,
      opponent: them.name,
      turn_over: you.turn_over
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

  def turn_over?(game, player) do
    over = false
    if (game.player1.name == player) do
      over = game.player1.turn_over
    else
      over = game.player2.turn_over
    end
    over
  end

  def player_click(game, player_name, key) do
    player = nil
    pKey = nil
    opponent = nil
    oKey = nil
    if (game.player1.name == player_name) do
      player = game.player1
      pKey = :player1
      opponent = game.player2
      oKey = :player2
    else
      player = game.player2
      pKey = :player2
      opponent = game.player1
      oKey = :player1
    end
    if game.started do
      player = Map.put(player, :turn_over, true)
      game = Map.put(game, pKey, player)
      hit = Enum.any?(opponent.ships, fn(ship) ->
        Enum.any?(ship, fn(cell) ->
          cell == key
        end)
      end)

      if hit do
        hits = player.hits ++ [key]
        player = Map.put(player, :hits, hits)
        ships = Enum.map(opponent.ships, fn(ship) ->
          Enum.reject(ship, fn(cell) -> cell == key end)
        end)
        opponent = Map.put(opponent, :ships, ships)
        sunk = Enum.count(opponent.ships, fn(ship) -> length(ship) == 0 end)
        opponent = Map.put(opponent, :sunk, sunk)
        game = Map.put(game, oKey, opponent)
      else
        misses = player.misses ++ [key]
        player = Map.put(player, :misses , misses)
      end
      game = Map.put(game, pKey, player)
    else
      {length, ships_to_place} = List.pop_at(player.ships_to_place, 0)
      keys = Enum.map(0..(length - 2), fn(x) ->
          iterate_key(player.horizontal, key, x)
      end)
      keys = List.insert_at(keys, 0, key)
      ships = List.insert_at(player.ships, 0, keys)
      player = Map.put(player, :ships, ships)
      player = Map.put(player, :ships_to_place, ships_to_place)

      game = Map.put(game, pKey, player)
      if (length(game.player1.ships_to_place) == 0) and (length(game.player2.ships_to_place) == 0) do
        game = Map.put(game, :started, true)
      end
      game
    end


  end

  defp iterate_key(horizontal, key, num) do
    chars = String.split(key, "")
    x = String.to_integer(Enum.at(chars, String.length(key) - 3))
    y = String.to_integer(Enum.at(chars, String.length(key) - 1))
    if horizontal do
      y = y + 1
      if y > 9 do
        y = 0
      end
    else
      x = x + 1
      if x > 9 do
        x = 0
      end
    end
    start = String.slice(key, 0..(String.length(key) -4))
    newKey = start <> Integer.to_string(x) <> "-" <> Integer.to_string(y)
    if (num != 0) do
      newKey = iterate_key(horizontal, newKey, num - 1)
    end
    newKey

  end



end
