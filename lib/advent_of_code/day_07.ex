defmodule AdventOfCode.Day07 do
  def part1(input) do
    positions = parse_positions(input)

    average = div(Enum.sum(positions), Enum.count(positions))
    {max_freq, _} = Enum.frequencies(positions) |> Enum.max_by(fn {_, v} -> v end)

    Enum.map(max_freq..average, fn x ->
      {x,
       positions
       |> Enum.map(&distance_from_point(&1, x))
       |> Enum.sum()}
    end)
    |> Enum.min_by(fn {_, v} -> v end)
    |> elem(1)
  end

  def distance_from_point(a, b), do: abs(b - a)

  defp parse_positions(input) do
    input
    |> String.replace("\n", "")
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  # 446

  def part2(input) do
    positions = parse_positions(input)

    {min, max} = Enum.min_max(positions)
    {max_freq, _} = Enum.frequencies(positions) |> Enum.max_by(fn {_, v} -> v end)
    halfway = div(min + max, 2)

    Enum.map(max_freq..halfway, fn x ->
      {x,
       positions
       |> Enum.map(&fuel_to_move_from(&1, x))
       |> Enum.sum()}
    end)
    |> Enum.min_by(fn {_, v} -> v end)
    |> elem(1)
  end

  def fuel_to_move_from(a, b) do
    Enum.sum(1..abs(a - b))
  end
end
