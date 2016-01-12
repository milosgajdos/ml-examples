defmodule LinearRegression do
  @doc """
  load_training_set initializes linear regression training set.
  Based on the passed in parameters TrainingSet is either loaded from a 
  specially formatted CSV file or read in directly from a TrainingSet struct
  """
  def load_training_set(ts = %TrainingSet{}) do
    ts
  end
  def load_training_set(path) do
    TrainingSet.load_from_file(path)
  end

  @doc """
  compute_cost implements multivariate linear regression cost function J
  It returns a single cost value for a given x, y and theta 
  """
  def compute_cost(x, y, theta) do
    {m, _} = ExMatrix.size(y)
    deltaX = ExMatrix.subtract(ExMatrix.multiply(x, theta), y)
    [cost | _] = List.flatten(ExMatrix.multiply(ExMatrix.transpose(deltaX), deltaX))
    cost/(2.0*m)
  end

  @doc """
  gradient_descent_with_cost performs gradient descent to learn theta parameters of 
  Linear Regression for a given training set. It returns a list that consits of two elements: 
  vector theta and list of cost history: [[theta1, theta2, ...], [costn, costn-1, ...]]
  """
  def gradient_descent_with_cost(x, y, theta, alpha, iters) do
    {m, _} = ExMatrix.size(y)
    1..iters
    |> Enum.reduce([theta, []],
      fn(_, [theta, cost]) ->
        theta = computeTheta(x, y, m, theta, alpha)
        j = compute_cost(x, y, theta)
        [theta, [j | cost]]
    end)
  end

  @doc """
  gradient_descent performs gradient descent to learn theta parameters of 
  Linear Regression for a given training set. It returns a theta vector 
  [[theta1, theta2, ...] that can be used to predict future values.
  """
  def gradient_descent(x, y, theta, alpha, iters) do
    {m, _} = ExMatrix.size(y)
    1..iters
    |> Enum.reduce(theta,
      fn(_, theta) ->
        computeTheta(x, y, m, theta, alpha)
    end)
  end

  defp computeTheta(x, y, m, theta, alpha) do
    deltaX = ExMatrix.subtract(ExMatrix.multiply(x, theta), y)
    deltaJ = ExMatrix.multiply(ExMatrix.transpose(x), deltaX)
    thetaJ = MxHelpers.per_element(deltaJ, fn(x) -> x*(alpha/m) end)
    ExMatrix.subtract(theta, thetaJ)
  end
end
