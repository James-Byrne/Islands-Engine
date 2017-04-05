defmodule IslandsEngine.Player do
  alias IslandsEngine.{Board, Coordinate, IslandSet, Player}

  defstruct name: :none, board: :none, island_set: :none

  # Create a player with a Board and  set of Islands (IslandSet)
  def start_link(name \\ :none) do
    {:ok, board} = Board.start_link
    {:ok, island_set} = IslandSet.start_link

    Agent.start_link(fn ->
      %Player{name: name, board: board, island_set: island_set}
    end)
  end

  # Set the players name
  def set_name(player, name) do
    Agent.update(player, fn state ->
      Map.put(state, :name, name)
    end)
  end

  # Print a string representation of the player
  def to_string(player) do
    "%Player{" <> string_body(player) <> "}"
  end

  # Return the internals of the Playet as a string
  defp string_body(player) do
    state = Agent.get(player, &(&1))
    ":name => " <> name_to_string(state.name) <> ",\n" <>
    ":island_set => " <> IslandSet.to_string(state.island_set) <> ",\n" <>
    ":board => " <> Board.to_string(state.board)
  end

  # Return the users name as a string
  defp name_to_string(:none), do: "none"
  defp name_to_string(name), do: name
end
