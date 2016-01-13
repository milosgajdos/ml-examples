defmodule MatrixHelpers do
  @doc """
  map applies function fun to each element of matrix passed in as a parameter
  ie. if matrix = [[1], [2]] and fun = fn(x) -> x*2 end 
  map will return [[2], [4]]
  """
  def map(mx, fun) do
    mx
    |> Stream.map(
      &List.foldr(&1, [],
        fn(x,acc) ->
          [fun.(x) | acc]
      end)
    )
    |> Enum.to_list
  end
end
