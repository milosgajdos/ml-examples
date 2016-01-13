defmodule GradientDescent do
  @doc """
  compute_cost implements gradient descent cost function J
  It returns a single cost value for a given x, y and theta 
  """
  def compute_cost(x, y, theta) do
    {m, _} = ExMatrix.size(y)
    deltaX = ExMatrix.subtract(ExMatrix.multiply(x, theta), y)
    [cost | _] = List.flatten(ExMatrix.multiply(ExMatrix.transpose(deltaX), deltaX))
    cost/(2.0*m)
  end

  @doc """
  compute_with_cost performs gradient descent to learn theta parameters
  from a given training set. It returns a list that consits of two elements: 
  vector theta and list of cost history: [[theta1, theta2, ...], [costn, costn-1, ...]]
  """
  def compute_with_cost(x, y, theta, alpha, iters) do
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
  gradient_descent performs gradient descent to learn theta parameters from
  a given training set. It returns model's theta vector [[theta1, theta2, ...] 
  """
  def compute(x, y, theta, alpha, iters) do
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
    thetaJ = MatrixHelpers.map(deltaJ, fn(x) -> x*(alpha/m) end)
    ExMatrix.subtract(theta, thetaJ)
  end
end
