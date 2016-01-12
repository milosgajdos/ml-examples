defmodule LinearRegressionTest do
  use ExUnit.Case
  doctest LinearRegression

  setup do
    ts = TrainingSet.load_from_file("test/training_set_uni_data.csv")
    alpha = 0.01
    iters = 500
    {:ok, fixtures: {ts.x, ts.y, alpha, iters}}
  end

  test "Compute gradient descent theta and cost for a given training set", %{fixtures: fixtures} do
    {x, y, alpha, iters} = fixtures
    {_, cols} = ExMatrix.size(x)
    initial_theta = ExMatrix.new_matrix(cols, 1)
    expected_theta = [[-2.2828672749589267], [1.0309989777517024]]
    [theta, _cost] = LinearRegression.get_model_and_cost(x, y, initial_theta, alpha, iters)
    assert expected_theta == theta
  end

  test "Compute gradient descent theta for given training set", %{fixtures: fixtures} do
    {x, y, alpha, iters} = fixtures
    {_, cols} = ExMatrix.size(x)
    initial_theta = ExMatrix.new_matrix(cols, 1)
    expected_theta = [[-2.2828672749589267], [1.0309989777517024]]
    theta = LinearRegression.get_model(x, y, initial_theta, alpha, iters)
    assert expected_theta == theta
  end
end
