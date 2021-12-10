defmodule AdventOfCode.Day09 do
  def part1(input) do
    [line | _] =
      lines =
      input
      |> String.split("\n", trim: true)

    map = get_coordinates(lines) |> Enum.into(%{})

    max_x = String.length(line)
    max_y = length(lines)

    for x <- 1..max_x, y <- 1..max_y do
      item = Map.get(map, {x, y})

      if Enum.all?(neighbours(x, y, max_x, max_y), fn neighbour ->
           Map.get(map, neighbour) > item
         end) do
        item
      end
    end
    |> Enum.filter(& &1)
    |> Enum.map(&(&1 + 1))
    |> Enum.sum()
  end

  def get_coordinates(lines) do
    lines
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(&Enum.with_index(&1, 1))
    |> Enum.with_index(1)
    |> Enum.map(fn {v, y} ->
      Enum.map(v, fn {d, x} ->
        {{x, y}, String.to_integer(d)}
      end)
    end)
    |> List.flatten()
  end

  def neighbours(x, y, max_x, max_y) do
    [
      {x + 1, y},
      # {x + 1, y + 1},
      {x, y + 1},
      {x, y - 1},
      {x - 1, y}
      # {x - 1, y - 1},
      # {x + 1, y - 1},
      # {x - 1, y + 1}
    ]
    |> Enum.filter(fn {vx, vy} -> vx >= 1 and vx <= max_x and vy >= 1 and vy <= max_y end)
  end

  def part2(input) do
    [line | _] =
      lines =
      input
      |> String.split("\n", trim: true)

    map = get_coordinates(lines)

    {_nines, others} = Enum.split_with(map, fn {_, v} -> v == 9 end)

    others_set =
      others
      |> Enum.into(%{})
      |> Map.keys()
      |> MapSet.new()

    max_x = String.length(line)
    max_y = length(lines)

    map = Enum.into(map, %{})

    {_, counts} =
      for x <- 1..max_x, y <- 1..max_y do
        item = Map.get(map, {x, y})

        if Enum.all?(neighbours(x, y, max_x, max_y), fn neighbour ->
             Map.get(map, neighbour) > item
           end) do
          {x, y}
        end
      end
      |> Enum.filter(& &1)
      |> Enum.reduce({others_set, %{}}, fn x, {set, counts} ->
        expand_outwards([x], x, set, counts)
      end)

    counts
    |> Map.values()
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.reduce(1, fn x, a -> a * x end)
  end

  def expand_outwards([], _original, others_set, acc), do: {others_set, acc}

  def expand_outwards([{x, y} | rest], original_point, others_set, acc) do
    {others_set, acc} =
      if MapSet.member?(others_set, {x, y}) do
        expand_outwards({x, y}, original_point, others_set, acc)
      else
        {others_set, acc}
      end

    expand_outwards(rest, original_point, others_set, acc)
  end

  def expand_outwards({x, y}, original_point, others_set, acc) do
    neighbours = neighbours_within_set(x, y, others_set)

    others_set = MapSet.delete(others_set, {x, y})

    expand_outwards(
      neighbours,
      original_point,
      others_set,
      Map.update(acc, original_point, 1, &(&1 + 1))
    )
  end

  def neighbours_within_set(x, y, set) do
    [
      {x + 1, y},
      {x, y + 1},
      {x, y - 1},
      {x - 1, y}
    ]
    |> Enum.filter(&MapSet.member?(set, &1))
  end
end
