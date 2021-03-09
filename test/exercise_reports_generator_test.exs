defmodule ExerciseReportsGeneratorTest do
  use ExUnit.Case

  describe "build/1" do
    test "builds and return parsed reports about freelances" do
      file_name = "reports.csv"

      result =
        file_name
        |> ExerciseReportsGenerator.build()
        |> Map.get(:all_hours)
        |> Map.get(:cleiton)

      expected_result = 13797

      assert expected_result == result
    end
  end
end
