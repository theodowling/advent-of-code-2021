defmodule AdventOfCode.Day14 do
  def part1(input) do
    [start | maps] =
      input
      |> String.split("\n", trim: true)

    start = String.codepoints(start)

    maps =
      Enum.map(maps, fn map ->
        [a, b] = String.split(map, " -> ", trim: true)
        {a, b}
      end)
      |> Enum.into(%{})

    {{_, min}, {_, max}} =
      iterate(start, maps, 9, [])
      |> Enum.frequencies()
      |> Enum.min_max_by(fn {_, v} -> v end)

    max - min
  end

  def iterate([_ | []], _maps, 0, acc), do: acc

  def iterate([_ | []], maps, n, acc) do
    # IO.puts("done with #{n}")

    acc
    |> Enum.reverse()
    |> iterate(maps, n - 1, [])
  end

  def iterate([a, b | rest], maps, n, []) do
    outcome = maps[a <> b]
    iterate([b | rest], maps, n, [b, outcome, a])
  end

  def iterate([a, b | rest], maps, n, acc) do
    outcome = maps[a <> b]
    iterate([b | rest], maps, n, [b, outcome | acc])
  end

  def part2(input) do
    [start | maps] =
      input
      |> String.split("\n", trim: true)

    start = String.codepoints(start)
    # IO.inspect(Enum.frequencies(start))

    maps =
      Enum.map(maps, fn map ->
        [a, b] = String.split(map, " -> ", trim: true)
        {a, b}
      end)
      |> Enum.into(%{})

    {{_, min}, {_, max}} =
      iterate(start, maps, 39, [])
      |> Enum.frequencies()
      |> Enum.min_max_by(fn {_, v} -> v end)

    max - min
  end
end
