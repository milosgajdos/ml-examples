defmodule MxHelpers do
  @doc """
  per_element applies function fun to each element of matrix mx
  ie. if mx = [[1], [2]] and fun = fn(x) -> x*2 end 
  it will return [[2], [4]]
  """
  def per_element(mx, fun) do
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
