defmodule AdventOfCode.Day12 do
  def part1(input) do
    paths =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "-"))
      |> Enum.reduce(%{}, fn [a, b], acc ->
        acc
        |> Map.update(a, [b], &[b | &1])
        |> Map.update(b, [a], &[a | &1])
      end)

    expand_from_start(paths, 1)
    |> count_lists()
  end

  def expand_from_start(paths, short_visits) do
    paths["start"]
    |> Enum.map(fn b ->
      [b, "start"]
    end)
    |> Enum.filter(&valid_path(&1, short_visits))
    |> Enum.map(&expand_further(&1, paths, short_visits))
  end

  def expand_further(["end" | _rest] = path, _paths, _), do: List.flatten(path)

  def expand_further([c | _rest] = path, paths, short_visits) do
    paths[c]
    |> Enum.map(fn b ->
      [b | path]
    end)
    |> Enum.filter(&valid_path(&1, short_visits))
    |> Enum.map(&expand_further(&1, paths, short_visits))
  end

  def major_point(<<head, _rest::binary>>) when head < ?a, do: true
  def major_point(_), do: false

  def valid_path(a, b, c \\ %{}, d \\ false)
  def valid_path([], _, _, _double_visited), do: true

  def valid_path([a | rest], short_visits, minors, double_visited) when a in ["start", "end"] do
    if Map.has_key?(minors, a) do
      false
    else
      valid_path(rest, short_visits, Map.update(minors, a, 1, &(&1 + 1)), double_visited)
    end
  end

  def valid_path([a | rest], short_visits, minors, double_visited) do
    if major_point(a) do
      valid_path(rest, short_visits, minors, double_visited)
    else
      short_visits = if double_visited, do: 1, else: short_visits

      if Map.get(minors, a, 0) >= short_visits do
        false
      else
        if Map.has_key?(minors, a) do
          valid_path(rest, short_visits, Map.update(minors, a, 1, &(&1 + 1)), true)
        else
          valid_path(rest, short_visits, Map.update(minors, a, 1, &(&1 + 1)), double_visited)
        end
      end
    end
  end

  def count_lists(lists) do
    List.flatten(lists)
    |> Enum.filter(fn x -> x == "start" end)
    |> Enum.count()
  end

  def part2(input) do
    paths =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "-"))
      |> Enum.reduce(%{}, fn [a, b], acc ->
        acc
        |> Map.update(a, [b], &[b | &1])
        |> Map.update(b, [a], &[a | &1])
      end)

    expand_from_start(paths, 2)
    |> count_lists()
  end
end
