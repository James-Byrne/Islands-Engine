defmodule IslandsEngine.Board do
  alias IslandsEngine.Coordinate

  @letters ~W(a b c d e f g h i j)
  @numbers [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

  # Start a new board agent. The agent is initialized with
  # a map containing all of the possible pairs of the
  # above letters & numbers [a1,a2,a3 ... j10]
  def start_link() do
    Agent.start_link(fn -> initialized_board() end)
  end

  # Create a map in the form [a1,a2,a3 ... j10]
  def keys() do
    for letter <- @letters, number <- @numbers do
      String.to_atom("#{letter}#{number}")
    end
  end

  # Given a board and a key (a1) look up that coord
  def get_coordinate(board, key) when is_atom key do
    Agent.get(board, fn board -> board[key] end)
  end

  # Mark a coordinate guessed as true
  def guess_coordinate(board, key) do
    get_coordinate(board, key)
    |> Coordinate.guess
  end

  # Check if a coordinate is hit
  def coordinate_hit?(board, key) do
    get_coordinate(board, key)
    |> Coordinate.hit?
  end

  # Set a coordinate as within an island
  def set_coordinate_in_island(board, key, island) do
    get_coordinate(board, key)
    |> Coordinate.set_in_island(island)
  end

  # Get a coordinates island
  def coordinate_island(board, key) do
    get_coordinate(board, key)
    |> Coordinate.island
  end

  # Initialize a board
  # Return a map with all of letter/number values
  defp initialized_board() do
    Enum.reduce(keys(), %{}, fn(key, board) ->
      {:ok, coord} = Coordinate.start_link
      Map.put_new(board, key, coord)
    end)
  end

  def to_string(board) do
    "%{" <> string_body(board) <> "}"
  end

  defp string_body(board) do
    Enum.reduce(keys(), "", fn (key, acc) ->
      coord = Agent.get(board, &(Map.fetch!(&1, key)))
      acc <> "#{key} => #{Coordinate.to_string(coord)},\n"
    end)
  end
end
