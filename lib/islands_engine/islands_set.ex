defmodule IslandsEngine.IslandSet do
  alias IslandsEngine.{Island, IslandSet}

  defstruct atoll: :none, dot: :none, l_shape: :none, s_shape: :none, sqaure: :none

  # Start a new Agent with an instance of initilized_set
  def start_link() do
    Agent.start_link(fn -> initialized_set() end)
  end

  # Get a list of the structs keys but without the `__struct__` param
  def keys() do
    %IslandSet{}
    |> Map.from_struct
    |> Map.keys
  end

  # Return a string respresentation of an island_set
  def to_string(island_set) do
    "%IslandSet{" <> string_body(island_set) <> "}"
  end

  # Return a string containing all values of an island_set
  defp string_body(island_set) do
    Enum.reduce(keys(), "", fn key, acc ->
      island =  Agent.get(island_set, &(Map.fetch!(&1, key)));
      acc <> "#{key} => " <> Island.to_string(island) <> "\n"
    end)
  end

  # Create a new IslandSet with an island for each item in the IslandSet struct
  defp initialized_set do
    Enum.reduce(keys(), %IslandSet{}, fn key, set ->
      {:ok, island} = Island.start_link

      Map.put(set, key, island)
    end)
  end
end
