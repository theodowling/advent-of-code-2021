defmodule AdventOfCode.Day14 do
  def part1(input) do
    [start | maps] =
      input
      |> String.split("\n", trim: true)

    start = start |> String.to_charlist() |> Enum.chunk_every(2, 1, [0])

    maps = Map.new(maps, fn <<i1, i2, " -> ", o>> -> {[i1, i2], o} end)

    result =
      Enum.reduce(1..10, start, fn _, polymer ->
        Enum.flat_map(polymer, fn [i1, i2] = pair ->
          case maps do
            %{^pair => o} -> [[i1, o], [o, i2]]
            %{} -> [pair]
          end
        end)
      end)
      |> Enum.map(&hd/1)

    {{_, min}, {_, max}} = result |> Enum.frequencies() |> Enum.min_max_by(&elem(&1, 1))
    max - min
  end

  def part2(input) do
    [start | maps] =
      input
      |> String.split("\n", trim: true)

    start = start |> String.to_charlist() |> Enum.chunk_every(2, 1, [0]) |> Enum.frequencies()

    maps = Map.new(maps, fn <<i1, i2, " -> ", o>> -> {[i1, i2], o} end)

    {{_, mins}, {_, maxes}} =
      1..40
      |> Enum.reduce(start, fn _, polymer ->
        Enum.reduce(polymer, %{}, fn {[i1, i2] = pair, count}, acc ->
          case maps do
            %{^pair => o} ->
              acc
              |> Map.update([i1, o], count, &(&1 + count))
              |> Map.update([o, i2], count, &(&1 + count))

            %{} ->
              Map.put(acc, pair, count)
          end
        end)
      end)
      |> Enum.group_by(&hd(elem(&1, 0)), &elem(&1, 1))
      |> Enum.min_max_by(fn {_, counts} -> Enum.sum(counts) end)

    Enum.sum(maxes) - Enum.sum(mins)
  end
end
