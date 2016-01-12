defmodule GradientDescentTest do
  use ExUnit.Case
  doctest GradientDescent

  setup do
    ts = TrainingSet.load_from_file("test/training_set_uni_data.csv")
    {:ok, fixtures: {ts.x, ts.y}}
  end

  test "Compute cost for empty initial theta", %{fixtures: fixtures} do
    {x, y} = fixtures
    {_, cols} = ExMatrix.size(x)
    initial_theta = ExMatrix.new_matrix(cols, 1)
    expected_cost = Float.to_string(32.072733877455654, [decimals: 2]) 
    computed_cost = Float.to_string(GradientDescent.compute_cost(x, y, initial_theta), [decimals: 2])
    assert expected_cost == computed_cost
  end
end
