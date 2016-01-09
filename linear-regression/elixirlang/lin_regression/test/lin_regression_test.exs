defmodule LinRegressionTest do
  use ExUnit.Case
  doctest LinRegression

  setup do
    {:ok, ts_data_path: "test/training_set_data.csv"}
  end

  test "load training set from CSV file", %{ts_data_path: ts_data_path} do
    ts = %LinRegression.TrainingSet{x: x} = LinRegression.load(ts_data_path)
    assert length(ts.x) > 0
  end

  test "Create new training set" do
    ts = %LinRegression.TrainingSet{x: x} = [1,2] |> LinRegression.TrainingSet.new
    assert length(ts.x) == 2
  end
end
