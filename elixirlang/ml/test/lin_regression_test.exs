defmodule LinRegressionTest do
  use ExUnit.Case
  doctest LinRegression

  setup do
    ts = TrainingSet.load_from_file("test/training_set_uni_data.csv")
    alpha = 0.01
    iters = 500
    {:ok, fixtures: {ts.x, ts.y, alpha, iters}}
  end

  test "Compute cost for empty initial theta", %{fixtures: fixtures} do
    {x, y, _, _} = fixtures
    {_, cols} = ExMatrix.size(x)
    initial_theta = ExMatrix.new_matrix(cols, 1)
    expected_cost = Float.to_string(32.072733877455654, [decimals: 2, compact: true]) 
    computed_cost = Float.to_string(LinRegression.compute_cost(x, y, initial_theta))
  end

  test "Compute gradient descent theta and cost for a given training set", %{fixtures: fixtures} do
    {x, y, alpha, iters} = fixtures
    {_, cols} = ExMatrix.size(x)
    initial_theta = ExMatrix.new_matrix(cols, 1)
    expected_theta = [[-2.2828672749589267], [1.0309989777517024]]
    [theta, _cost] = LinRegression.gradient_descent_with_cost(x, y, initial_theta, alpha, iters)
    assert expected_theta == theta
  end

  test "Compute gradient descent theta for given training set", %{fixtures: fixtures} do
    {x, y, alpha, iters} = fixtures
    {_, cols} = ExMatrix.size(x)
    initial_theta = ExMatrix.new_matrix(cols, 1)
    expected_theta = [[-2.2828672749589267], [1.0309989777517024]]
    theta = LinRegression.gradient_descent(x, y, initial_theta, alpha, iters)
    assert expected_theta == theta
  end
end
