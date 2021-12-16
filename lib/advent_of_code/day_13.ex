defmodule AdventOfCode.Day13 do
  def part1(input) do
    {instructions, coordinates} =
      input
      |> String.split("\n", trim: true)
      |> Enum.split_with(fn x -> x =~ "fold along" end)

    map =
      coordinates
      |> Enum.map(fn x ->
        [x, y] = String.split(x, ",", trim: true)
        {String.to_integer(x), String.to_integer(y)}
      end)

    [first_instruction | _rest] =
      instructions
      |> Enum.map(fn
        "fold along x=" <> x ->
          {:x, String.to_integer(x)}

        "fold along y=" <> y ->
          {:y, String.to_integer(y)}
      end)

    perform_fold(map, first_instruction)
    |> Enum.uniq()
    |> Enum.count()
  end

  def perform_fold(a, b, c \\ [])

  def perform_fold([], _, acc), do: acc

  def perform_fold([{x, y} | rest], {:y, y_fold}, acc) when y < y_fold do
    perform_fold(rest, {:y, y_fold}, [{x, y} | acc])
  end

  def perform_fold([{x, y} | rest], {:y, y_fold}, acc) do
    perform_fold(rest, {:y, y_fold}, [{x, y_fold - (y - y_fold)} | acc])
  end

  def perform_fold([{x, y} | rest], {:x, x_fold}, acc) when x < x_fold do
    perform_fold(rest, {:x, x_fold}, [{x, y} | acc])
  end

  def perform_fold([{x, y} | rest], {:x, x_fold}, acc) do
    perform_fold(rest, {:x, x_fold}, [{x_fold - (x - x_fold), y} | acc])
  end

  def part2(input) do
    {instructions, coordinates} =
      input
      |> String.split("\n", trim: true)
      |> Enum.split_with(fn x -> x =~ "fold along" end)

    map =
      coordinates
      |> Enum.map(fn x ->
        [x, y] = String.split(x, ",", trim: true)
        {String.to_integer(x), String.to_integer(y)}
      end)

    instructions =
      instructions
      |> Enum.map(fn
        "fold along x=" <> x ->
          {:x, String.to_integer(x)}

        "fold along y=" <> y ->
          {:y, String.to_integer(y)}
      end)

    output =
      Enum.reduce(instructions, map, fn instruction, map ->
        perform_fold(map, instruction) |> Enum.uniq()
      end)

    {{x1, y1}, {x2, y2}} = Enum.min_max(output)

    output_mapset = MapSet.new(output)

    Enum.map((y1 - 1)..(y2 + 1), fn y ->
      Enum.map((x1 - 1)..(x2 + 1), fn x ->
        if MapSet.member?(output_mapset, {x, y}) do
          "#"
        else
          " "
        end
      end)
      |> Enum.join("")
    end)
    |> Enum.join("\n")
  end
end
