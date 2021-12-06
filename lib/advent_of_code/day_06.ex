defmodule AdventOfCode.Day06 do
  def part1(input) do
    input
    |> String.replace("\n", "")
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> count_fish_at_day(80)
  end

  def count_fish_at_day(state, n) do
    state
    |> iterate_days(n)
    |> Enum.count()
  end

  defp iterate_days(state, 0), do: state

  defp iterate_days(state, remaining_days) do
    state
    |> age_laternfish([])
    |> iterate_days(remaining_days - 1)
  end

  defp age_laternfish([], acc), do: acc

  defp age_laternfish([fish | rest], acc)
       when fish == 0,
       do: age_laternfish(rest, [6, 8 | acc])

  defp age_laternfish([fish | rest], acc) do
    age_laternfish(rest, [fish - 1 | acc])
  end

  def part2(input) do
    input
    |> String.replace("\n", "")
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> create_spawn_cycle(%{})
    |> recurse_through_days(Enum.to_list(-7..256))
    |> Map.values()
    |> Enum.sum()
  end

  defp create_spawn_cycle([], acc), do: acc

  defp create_spawn_cycle([fish | rest], acc) do
    create_spawn_cycle(rest, Map.update(acc, fish - 8, 1, &(&1 + 1)))
  end

  defp recurse_through_days(map, []), do: map

  defp recurse_through_days(map, [day | rest]) do
    first = Map.get(map, day, 0)

    map =
      if first > 0 do
        Enum.take_while(1..37, fn x -> day + 2 + x * 7 <= 256 end)
        |> Enum.map(fn
          1 -> day + 9
          x -> day + 2 + x * 7
        end)
        |> Enum.reduce(map, fn x, acc ->
          Map.update(acc, x, first, &(&1 + first))
        end)
      else
        map
      end

    recurse_through_days(map, rest)
  end
end
