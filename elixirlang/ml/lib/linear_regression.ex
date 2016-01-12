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
  get_model_and_cost performs a gradient descent over training data set and returns
  a list that contains a learnt vector theta that can be used to predict future values and
  a list of gradient descent cost of each iteration
  """
  def get_model_and_cost(x, y, theta, alpha, iters) do
    GradientDescent.compute_with_cost(x, y, theta, alpha, iters)
  end

  def get_model_and_cost(%TrainingSet{x: x, y: y}, theta, alpha, iters) do
    GradientDescent.compute_with_cost(x, y, theta, alpha, iters)
  end

  @doc """
  get_model performs gradient descent just like get_model_and_cost, but it does not return
  a list of gradient descent costs, it only returns a vector of model's parameters theta
  """
  def get_model(x, y, theta, alpha, iters) do
    GradientDescent.compute(x, y, theta, alpha, iters)
  end

  def get_model(%TrainingSet{x: x, y: y}, theta, alpha, iters) do
    GradientDescent.compute(x, y, theta, alpha, iters)
  end
end
