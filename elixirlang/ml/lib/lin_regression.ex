defmodule LinRegression do
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
    delta  = ExMatrix.subtract(y, ExMatrix.multiply(x, theta))
    [cost | _] = List.flatten(ExMatrix.multiply(ExMatrix.transpose(delta), delta))
    cost/(2.0*m)
  end
end
