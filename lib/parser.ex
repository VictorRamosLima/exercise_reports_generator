defmodule ExerciseReportsGenerator.Parser do
  @months %{
    1 => :janeiro,
    2 => :fevereiro,
    3 => :março,
    4 => :abril,
    5 => :maio,
    6 => :junho,
    7 => :julho,
    8 => :agosto,
    9 => :setembro,
    10 => :outubro,
    11 => :novembro,
    12 => :dezembro
  }

  def parse_file(file_name) do
    "reports/#{file_name}"
    |> File.stream!()
    |> Stream.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.downcase()
    |> String.split(",")
    |> List.update_at(0, &String.to_atom/1)
    |> List.update_at(1, &String.to_integer/1)
    |> List.update_at(2, &String.to_integer/1)
    |> List.update_at(3, &String.to_integer/1)
    |> List.update_at(3, &to_month/1)
    |> List.update_at(4, &String.to_integer/1)
  end

  defp to_month(month_number) do
    @months[month_number]
  end
end
