defmodule ExerciseReportsGenerator do
  alias ExerciseReportsGenerator.Parser

  @names [
    :danilo,
    :diego,
    :rafael,
    :joseph,
    :giuliano,
    :daniele,
    :jakeliny,
    :vinicius,
    :cleiton,
    :mayk
  ]

  @months %{
    janeiro: 0,
    fevereiro: 0,
    março: 0,
    abril: 0,
    maio: 0,
    junho: 0,
    julho: 0,
    agosto: 0,
    setembro: 0,
    outubro: 0,
    novembro: 0,
    dezembro: 0
  }

  @years %{
    2016 => 0,
    2017 => 0,
    2018 => 0,
    2019 => 0,
    2020 => 0
  }

  def build(file_name) do
    file_name
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), &reduce_values(&1, &2))
  end

  defp reduce_values(
    [name, hours, _day, month, year],
    %{
      all_hours: all_hours,
      hours_per_month: hours_per_month,
      hours_per_year: hours_per_year
    } = report
  ) do
    name_hours = hours_per_month[name]
    name_years = hours_per_year[name]

    all_hours = Map.put(all_hours, name, all_hours[name] + hours)

    name_hours = Map.put(name_hours, month, name_hours[month] + hours)
    hours_per_month = Map.put(hours_per_month, name, name_hours)

    name_years = Map.put(name_years, year, name_years[year] + hours)
    hours_per_year = Map.put(hours_per_year, name, name_years)

    report
    |> Map.put(:all_hours, all_hours)
    |> Map.put(:hours_per_month, hours_per_month)
    |> Map.put(:hours_per_year, hours_per_year)
  end

  def report_acc do
    all_hours = Enum.into(@names, %{}, &{&1, 0})
    hours_per_month = Enum.into(@names, %{}, &{&1, @months})
    hours_per_year = Enum.into(@names, %{}, &{&1, @years})

    %{
      all_hours: all_hours,
      hours_per_month: hours_per_month,
      hours_per_year: hours_per_year
    }
  end
end
