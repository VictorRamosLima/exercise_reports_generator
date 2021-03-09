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

  def build_from_many(filenames) when not is_list(filenames) do
    {:error, "List of strings was not passed"}
  end

  def build_from_many(filenames) do
    result =
      filenames
      |> Task.async_stream(&build/1)
      |> Enum.reduce(
        report_acc(),
        fn {:ok, result}, report -> reduce_reports(result, report) end
      )

    {:ok, result}
  end

  defp reduce_reports(
    %{
      all_hours: previous_all_hours,
      hours_per_month: previous_hours_per_month,
      hours_per_year: previous_hours_per_year
    },
    %{
      all_hours: current_all_hours,
      hours_per_month: current_hours_per_month,
      hours_per_year: current_hours_per_year
    }
  ) do
    all_hours = merge_maps(previous_all_hours, current_all_hours)
    hours_per_month = mount_map(previous_hours_per_month, current_hours_per_month)
    hours_per_year = mount_map(previous_hours_per_year, current_hours_per_year)

    %{
      all_hours: all_hours,
      hours_per_month: hours_per_month,
      hours_per_year: hours_per_year
    }
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

  defp mount_map(previous_map, current_map) do
    Enum.reduce(
      @names,
      %{},
      fn name, acc ->
        Map.put(
          acc,
          name,
          merge_maps(previous_map[name], current_map[name])
        )
      end
    )
  end

  defp merge_maps(previous_map, current_map) do
    Map.merge(
      previous_map,
      current_map,
      fn _key, previous_values, current_values -> previous_values + current_values end
    )
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
