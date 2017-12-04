defmodule Battleship.Player do
  def new(player) do
    %{
      name: player,
      ships_to_place: [5, 4, 3, 3, 2],
      ships: [],
      hits: [],
      misses: [],
      sunk: 0,
      turn_over: false,
      horizontal: true
    }
end
end
