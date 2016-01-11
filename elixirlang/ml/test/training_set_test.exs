defmodule TrainingSetTest do
  use ExUnit.Case
  doctest TrainingSet

  setup do
    {:ok, ts_data_path: "test/training_set_data.csv"}
  end

  test "Load training set from CSV file", %{ts_data_path: ts_data_path} do
    %TrainingSet{x: x, y: y} = TrainingSet.load_from_file(ts_data_path)
    assert length(x) == length(y)
    assert length(x) == 47
  end

  test "Create new training set" do
    mock_data = [[[1, 2], [3, 4]], [5, 6]]
    %TrainingSet{x: x, y: y} = mock_data |> TrainingSet.new
    assert length(x) == 2 and length(y) == 2
    assert [1,2] = List.first(x)
    assert 5 = List.first(y)
  end
end
