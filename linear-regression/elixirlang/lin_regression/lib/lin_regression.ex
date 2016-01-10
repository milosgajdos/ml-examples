defmodule LinRegression do
  defmodule TrainingSet do
    defstruct x: [], y: []
    @doc """
    Creates new TrainingSet struct. x is features matrix, y is a vector of measurements
    """
    def new([x|y]) do
      %TrainingSet{x: x, y: List.flatten(y)}
    end
  end

  @doc """
  Loads training set data from a CSV file passed in as parameter into %TrainingSet{}
  """
  def load_training_set(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&String.split(&1, ",", trim: true))
    |> Stream.map(
      fn(row) ->
        List.foldr(row, [], &([String.to_integer(&1)/1.0| &2]))
        |> Enum.reverse
        |> List.foldl([[]], 
          fn(x, acc = [h|t]) ->
            case length(t) do
              0 -> [[],[x]]
              _ ->
                [h_acc | _t_acc] = acc
                [[x|h_acc], List.flatten(t)]
            end
        end)
    end)
    |> Enum.reduce([[]],
      fn([h_x|t_x], [h_acc|t_acc]) ->
        [[h_x|h_acc], List.flatten([t_x|t_acc])]
    end)
    |> TrainingSet.new
  end
end
