defmodule LinRegressionTest do
  use ExUnit.Case
  doctest LinRegression

  setup do
    {:ok, ts_data_path: "test/training_set_data.csv"}
  end

  test "load training set from CSV file", %{ts_data_path: ts_data_path} do
    %LinRegression.TrainingSet{x: x, y: y} = LinRegression.load_training_set(ts_data_path)
    assert length(x) == length(y)
  end

  test "Create new training set" do
    %LinRegression.TrainingSet{x: x, y: y} = [[[1,2]], [3]] |> LinRegression.TrainingSet.new
    assert length(x) == 1 and length(y) == 1
  end
end
