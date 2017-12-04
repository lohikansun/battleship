require IEx
defmodule BattleshipWeb.TableChannel do
  use BattleshipWeb, :channel
  alias Battleship.Agent
  alias Battleship.Chat

  def join("table:" <> name, payload, socket) do
    if authorized?(payload) do
      chat = Agent.get(name) || Chat.new()
      Agent.put(name, chat)
      socket = socket
      |> assign(:table_name, name)
      {:ok, chat, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("newPlayer", payload, socket) do
    name = socket.assigns[:table_name]
    socket = socket
    |> assign(:user, payload)
    chat = Agent.get(name)
    chat = Chat.add_player(chat, payload)
    Agent.put(name, chat)
    broadcast socket, "state", chat
    {:reply, {:ok, chat}, socket}
  end

  def handle_in("message", %{"message" => message}, socket) do
    user = socket.assigns[:user]
    table = socket.assigns[:table_name]
    chat = Agent.get(table)
    chat = Chat.add_message(chat, message, user)
    Agent.put(table, chat)
    broadcast socket, "state", chat
    {:reply, {:ok, chat}, socket}
  end

  def handle_in("challenge", %{"player" => player}, socket) do
    user = socket.assigns[:user]
    table = socket.assigns[:table_name]
    chat = Agent.get(table)
    chat = Chat.start_game(chat, user, player)
    Agent.put(table, chat)
    broadcast socket, "challenge", chat
    {:reply, {:ok, chat}, socket}

  end

  def handle_in("endGame",params, socket) do
    user = socket.assigns[:user]
    table = socket.assigns[:table_name]
    gameName = table <> "Game"
    game =  Agent.get(gameName)
    Agent.put(gameName, nil)
    chat = Agent.get(table)
    chat = Map.put(chat, :lastWinner, game.winner)
    chat = Chat.end_game(chat)
    Agent.put(table, chat)
    broadcast socket, "end", chat
    {:reply, {:ok, chat}, socket}

  end

  def terminate(reason, socket) do
    user = socket.assigns[:user]
    table = socket.assigns[:table_name]
    chat = Agent.get(table)
    chat = Chat.remove_player(chat, user)
    Agent.put(table, chat)
    broadcast socket, "state", chat
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
