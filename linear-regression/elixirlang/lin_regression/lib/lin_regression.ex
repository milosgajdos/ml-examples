defmodule LinRegression do
  defmodule TrainingSet do
    defstruct x: []
    @doc """
    Creates new TrainingSet
    """
    def new(data \\ []) do
      %TrainingSet{x: data}
    end
  end

  @doc """
  Loads training set data from a CSV file passed in as parameter into %TrainingSet{}
  """
  def load(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&String.split(&1, ",", trim: true))
    |> Stream.map(
        fn(row) -> 
          List.foldr(row, [], &([String.to_integer(&1)/1.0 | &2]))
        end)
    |> Enum.into([])
    |> TrainingSet.new
  end
end
