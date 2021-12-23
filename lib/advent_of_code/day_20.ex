defmodule AdventOfCode.Day20 do
  import Bitwise

  def part1(input) do
    [line | map] =
      input
      |> String.split("\n", trim: true)

    algorithm =
      line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.map(fn {k, v} -> {v, (k == "#" && 1) || 0} end)
      |> Map.new()

    pic =
      for {line, row} <- Enum.with_index(map),
          {cell, col} <- line |> String.split("", trim: true) |> Enum.with_index(),
          into: %{} do
        {{row, col}, (cell == "#" && 1) || 0}
      end

    pic
    |> iterate(algorithm, 2)
  end

  def iterate(pic, _algorithm, 0), do: pic

  def iterate(pic, algorithm, n) do
    new_pic =
      Enum.reduce(1..n, pic, fn count, pic ->
        enhance(pic, algorithm, count, %{})
      end)

    {{min_row, min_col}, {max_row, max_col}} = new_pic |> Map.keys() |> Enum.min_max()

    # for row <- min_row..max_row do
    #   for col <- min_col..max_col do
    #     (new_pic[{row, col}] == 1 && "#") || "."
    #   end
    #   |> IO.puts()
    # end

    for row <- min_row..max_row, col <- min_col..max_col do
      new_pic[{row, col}] == 1
    end
    |> Enum.reject(&(!&1))
    |> Enum.count()
  end

  def enhance(pic, alg, count, new_pic) do
    field = count - 1 &&& alg[0]
    {{min_row, min_col}, {max_row, max_col}} = pic |> Map.keys() |> Enum.min_max()

    for row <- (min_row - 3)..(max_row + 3), col <- (min_col - 3)..(max_col + 3), into: new_pic do
      {row, col}
      |> neighbours
      |> Enum.map(&Map.get(pic, &1, field))
      |> Integer.undigits(2)
      |> then(fn i -> {{row, col}, alg[i]} end)
    end
  end

  def neighbours({x, y}) do
    for row_offset <- -1..1, col_offset <- -1..1 do
      {x + row_offset, y + col_offset}
    end
  end

  def part2(input) do
    [line | map] =
      input
      |> String.split("\n", trim: true)

    algorithm =
      line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.map(fn {k, v} -> {v, (k == "#" && 1) || 0} end)
      |> Map.new()

    pic =
      for {line, row} <- Enum.with_index(map),
          {cell, col} <- line |> String.split("", trim: true) |> Enum.with_index(),
          into: %{} do
        {{row, col}, (cell == "#" && 1) || 0}
      end

    pic
    |> iterate(algorithm, 50)
  end
end
