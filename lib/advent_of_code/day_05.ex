defmodule AdventOfCode.Day05 do
  def part1(inputs) do
    inputs
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [a, b] = String.split(line, " -> ", trim: true)
      [x1, y1] = String.split(a, ",", trim: true)
      [x2, y2] = String.split(b, ",", trim: true)

      [
        {String.to_integer(x1), String.to_integer(y1)},
        {String.to_integer(x2), String.to_integer(y2)}
      ]
    end)
    |> generate_linear_coordinate_points(%{})
    |> count_where_multiple()
  end

  defp generate_linear_coordinate_points([], acc), do: acc

  defp generate_linear_coordinate_points([[{x1, y1}, {x2, y2}] | rest], acc) do
    coords =
      get_all_linear_coortinates({x1, y1}, {x2, y2})
      |> Enum.reduce(acc, fn k, acc1 ->
        Map.update(acc1, k, 1, &(&1 + 1))
      end)

    generate_linear_coordinate_points(rest, coords)
  end

  def get_all_linear_coortinates({x1, y1}, {x2, y2})
      when x1 == x2,
      do: Enum.map(y1..y2, fn y -> {x1, y} end)

  def get_all_linear_coortinates({x1, y1}, {x2, y2})
      when y1 == y2,
      do: Enum.map(x1..x2, fn x -> {x, y1} end)

  def get_all_linear_coortinates(_, _), do: []

  defp generate_coordinate_points([], acc), do: acc

  defp generate_coordinate_points([[{x1, y1}, {x2, y2}] | rest], acc) do
    coords =
      get_all_coortinates({x1, y1}, {x2, y2})
      |> Enum.reduce(acc, fn k, acc1 ->
        Map.update(acc1, k, 1, &(&1 + 1))
      end)

    generate_coordinate_points(rest, coords)
  end

  def get_all_coortinates({x1, y1}, {x2, y2})
      when x1 == x2,
      do: Enum.map(y1..y2, fn y -> {x1, y} end)

  def get_all_coortinates({x1, y1}, {x2, y2})
      when y1 == y2,
      do: Enum.map(x1..x2, fn x -> {x, y1} end)

  def get_all_coortinates({x1, y1}, {x2, y2}) do
    xn = if x1 > x2, do: -1, else: 1
    yn = if y1 > y2, do: -1, else: 1

    n = abs(x2 - x1)

    for i <- 0..n do
      {x1 + i * xn, y1 + i * yn}
    end
  end

  def count_where_multiple(points) do
    points
    |> Enum.count(fn {_, v} -> v > 1 end)
  end

  def part2(inputs) do
    inputs
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [a, b] = String.split(line, " -> ", trim: true)
      [x1, y1] = String.split(a, ",", trim: true)
      [x2, y2] = String.split(b, ",", trim: true)

      [
        {String.to_integer(x1), String.to_integer(y1)},
        {String.to_integer(x2), String.to_integer(y2)}
      ]
    end)
    |> generate_coordinate_points(%{})
    |> count_where_multiple()
  end
end
