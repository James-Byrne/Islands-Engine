defmodule IslandsEngine.Island do
  alias IslandsEngine.Coordinate

  # Start a link with a new Island Agent whose initial state is an empty list
  def start_link do
    Agent.start_link(fn -> [] end)
  end

  # Replace the coordinates of the island with anew list of coords
  # This is passed coordinates from the Boards list of coordinates
  def replace_coordinates(island, new_coords) when is_list new_coords do
    Agent.update(island, fn _state -> new_coords end)
  end

  # Check if the island has a palm tree
  # Check if all the islands coordinates have been hit
  def forested?(island) do
    Agent.get(island, fn state -> state end)
    |> Enum.all?(fn coord -> Coordinate.hit?(coord) === true end)
  end

  # Print the islands current state as a string
  def to_string(island) do
    string = Agent.get(island, fn state -> state end)
    |> Enum.reduce("", fn coord, acc -> "#{acc}, #{Coordinate.to_string(coord)}" end)

    "[" <> String.replace_leading(string, ",", "") <> "]"
  end
end
