defmodule LinRegressionTest do
  use ExUnit.Case
  doctest LinRegression

  setup do
    {:ok, training_set: TrainingSet.load_from_file("test/training_set_uni_data.csv")}
  end

  test "Compute cost for empty initial theta", %{training_set: training_set} do
    x = training_set.x
    y = training_set.y
    {_, cols} = ExMatrix.size(x)
    theta = ExMatrix.new_matrix(cols, 1)
    expected_cost = Float.to_string(32.072733877455654, [decimals: 2, compact: true]) 
    computed_cost = Float.to_string(LinRegression.compute_cost(x, y, theta))
  end
end
