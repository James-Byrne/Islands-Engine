defmodule IslandsEngine.Coordinate do
  alias IslandsEngine.Coordinate

  # in_island => Holds the name of the island or :none
  # guessed => Has the user guessed this coordinate?
  defstruct in_island: :none, guessed?: false

  # Start a link with a new Agent whose state is a Coordinate instance
  def start_link() do
    Agent.start_link(fn -> %Coordinate{} end)
  end

  # Check if the coordinate has been guessed (guessed will be true | false)
  def guessed?(coordinate) do
    Agent.get(coordinate, fn state -> state.guessed? end)
  end

  # Check if coordinate is in an island (returns :none or island name (as an atom))
  def island(coordinate) do
    Agent.get(coordinate, fn state -> state.in_island end)
  end

  # Check if the coordinate is in an island and return a bool
  def in_island?(coordinate) do
    case Agent.get(coordinate, fn state -> state.in_island end) do
      :none -> false
      _ -> true
    end
  end

  # Check if the coordinate has been hit
  def hit?(coordinate) do
    Coordinate.in_island?(coordinate) && Coordinate.guessed?(coordinate)
  end

  # Guess the coordinate (Updates Coordinate guessed to true)
  def guess(coordinate) do
    Agent.update(coordinate, fn state -> Map.put(state, :guessed?, true) end)
  end

  # Set the current coordinate as within an island
  def set_in_island(coordinate, value) when is_atom value do
    Agent.update(coordinate, fn state -> Map.put(state, :in_island, value) end)
  end

  # Return the coordinate as a string
  def to_string(coordinate) do
    "(in_island:#{island(coordinate)}, guessed:#{guessed?(coordinate)})"
  end
end
