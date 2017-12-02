defmodule Battleship.Player do
  def new(player) do
    %{
      name: player,
      ships_to_place: [5, 4, 3, 3, 2],
      ships: [],
      hits: [],
      misses: [],
      horizontal: true
    }
end
end
