defmodule ExerciseReportsGenerator.ParserTest do
  use ExUnit.Case

  alias ExerciseReportsGenerator.Parser

  describe "parse_file/1" do
    test "returns parsed file" do
      result =
        "reports.csv"
        |> Parser.parse_file()
        |> Enum.map(& &1)
        |> hd()

      expected_result = [:daniele, 7, 29, :abril, 2018]

      assert expected_result == result
    end
  end
end
