defmodule AdventOfCode.Day22 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line(&1, -50, 50))
    |> Enum.reduce(MapSet.new(), fn
      {:on, x1, x2, y1, y2, z1, z2}, acc ->
        for x <- x1..x2, y <- y1..y2, z <- z1..z2, reduce: acc do
          acc -> MapSet.put(acc, {x, y, z})
        end
        |> tap(&IO.inspect(MapSet.size(&1)))

      {:off, x1, x2, y1, y2, z1, z2}, acc ->
        for x <- x1..x2, y <- y1..y2, z <- z1..z2, reduce: acc do
          acc -> MapSet.delete(acc, {x, y, z})
        end
        |> tap(&IO.inspect(MapSet.size(&1)))

      :ignore, acc ->
        acc
    end)
    |> MapSet.size()
  end

  def parse_line(line, min_a, max_a) do
    [action, x1, x2, y1, y2, z1, z2] =
      line
      |> String.split([" ", "x=", ",y=", ",z=", ".."], trim: true)

    a1 = String.to_integer(x1)
    a2 = String.to_integer(x2)
    b1 = String.to_integer(y1)
    b2 = String.to_integer(y2)
    c1 = String.to_integer(z1)
    c2 = String.to_integer(z2)

    {x1, x2} = if a1 > a2, do: {a2, a1}, else: {a1, a2}
    {y1, y2} = if b1 > b2, do: {b2, b1}, else: {b1, b2}
    {z1, z2} = if c1 > c2, do: {c2, c1}, else: {c1, c2}

    if (x1 < min_a and x2 < min_a) or
         (y1 < min_a and y2 < min_a) or
         (z1 < min_a and z2 < min_a) or
         (x1 > max_a and x2 > max_a) or
         (y1 > max_a and y2 > max_a) or
         (z1 > max_a and z2 > max_a) do
      :ignore
    else
      {
        String.to_atom(action),
        min(max(min_a, x1), max_a),
        max(min(max_a, x2), min_a),
        min(max(min_a, y1), max_a),
        max(min(max_a, y2), min_a),
        min(max(min_a, z1), max_a),
        max(min(max_a, z2), min_a)
      }
    end
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line(&1, -9_999_999, 9_999_999))
    |> Enum.reduce(MapSet.new(), fn
      {:on, x1, x2, y1, y2, z1, z2}, acc ->
        for x <- x1..x2, y <- y1..y2, z <- z1..z2, reduce: acc do
          acc -> MapSet.put(acc, {x, y, z})
        end

      {:off, x1, x2, y1, y2, z1, z2}, acc ->
        for x <- x1..x2, y <- y1..y2, z <- z1..z2, reduce: acc do
          acc -> MapSet.delete(acc, {x, y, z})
        end

      :ignore, acc ->
        acc
    end)
    |> MapSet.size()
  end
end
