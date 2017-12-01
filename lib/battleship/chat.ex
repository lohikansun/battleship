require IEx
defmodule Battleship.Chat do

def new do
  %{
    players: [],
    messages: [],
    gameActive: false,
    challenged: "",
    challenger: ""
  }
end


def add_player(chat, player) do
  p = chat.players
  p = p ++ [player]
  p = Enum.uniq(p)
  Map.put(chat, :players, p)
end

def remove_player(chat, player) do
  p = chat.players
  p = Enum.filter(p, fn(x) -> x != player end)
  Map.put(chat, :players, p)
end

def add_message(chat, message, user) do
  m = %{text: message, player: user}
  messages= chat.messages
  messages = messages ++ [m]
  Map.put(chat, :messages, messages)
end

def start_game(chat, challenger, challenged) do
  chat = Map.put(chat, :challenged, challenged)
  chat = Map.put(chat, :challenger, challenger)
  Map.put(chat, :gameActive, true)
end

def end_game(chat) do
  chat = Map.put(chat, :challenged, "")
  chat = Map.put(chat, :challenger, "")
  Map.put(chat, :gameActive, false)
end

end
