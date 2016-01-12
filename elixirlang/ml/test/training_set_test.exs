defmodule TrainingSetTest do
  use ExUnit.Case
  doctest TrainingSet

  setup do
    {:ok, ts_data_path: "test/training_set_multi_data.csv"}
  end

  test "Load training set from CSV file", %{ts_data_path: ts_data_path} do
    data_size = 47
    %TrainingSet{x: x, y: y} = TrainingSet.load_from_file(ts_data_path)
    assert length(x) == data_size && length(y) == data_size
  end

  test "Create new training set and check the order of x and y" do
    mock_data = [x_mock, y_mock] = [[[1, 2], [3, 4]], [[5], [6]]]
    %TrainingSet{x: x, y: y} = mock_data |> TrainingSet.new
    assert length(x) == length(x_mock) and length(y) == length(y_mock)
    assert List.first(x) == List.first(x_mock)
    assert List.first(y) == List.first(y_mock)
  end
end
