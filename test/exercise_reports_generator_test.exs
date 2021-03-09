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

  describe "build_from_many/1" do
    test "builds from many files and return parsed reports about freelances" do
      extract_reports = fn {:ok, report} -> report end
      file_names = ["part_1.csv", "part_2.csv", "part_3.csv"]

      result =
        file_names
        |> ExerciseReportsGenerator.build_from_many()
        |> extract_reports.()
        |> Map.get(:all_hours)
        |> Map.get(:cleiton)

      expected_result = 13797

      assert expected_result == result
    end

    test "when a list is not given, returns a error" do
      file_names = :not_a_string_list

      result =
        file_names
        |> ExerciseReportsGenerator.build_from_many()

      expected_result = {:error, "List of strings was not passed"}

      assert expected_result == result
    end
  end
end
