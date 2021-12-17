defmodule AdventOfCode.Day17 do
  def part1("target area: x=" <> rest) do
    [x_range, y_range] = String.split(rest, ", y=", trim: true)

    [x1, x2] =
      x_range
      |> String.split("..", trim: true)
      |> Enum.map(&String.to_integer/1)

    [y1, y2] =
      y_range
      |> String.split("..", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort(:desc)

    target =
      for(
        x <- x1..x2,
        y <- y1..y2,
        do: {x, y}
      )

    end_point = Enum.at(target, -1)

    start = {0, 0}

    for x <- 0..x1, y <- 0..20 do
      {{x, y}, play_until_hit_or_miss(start, {x, y}, MapSet.new(target), end_point, {0, 0})}
    end
    |> Enum.filter(&(elem(elem(&1, 1), 0) == :hit))
    |> Enum.max_by(fn {_point, {:hit, {_, y}}} -> y end)
    |> elem(1)
    |> elem(1)
    |> elem(1)
  end

  def play_until_hit_or_miss({x, y}, {_x_change, _y_change}, _target, {xe, ye}, _highest)
      when x > xe or y < ye do
    {:miss, nil}
  end

  def play_until_hit_or_miss({x, y}, {x_change, y_change}, target, {xe, ye}, highest) do
    highest = if y > elem(highest, 1), do: {x, y}, else: highest

    if MapSet.member?(target, {x, y}) do
      {:hit, highest}
    else
      play_until_hit_or_miss(
        {x + x_change, y + y_change},
        {
          if(x_change == 0, do: 0, else: x_change - 1),
          y_change - 1
        },
        target,
        {xe, ye},
        highest
      )
    end
  end

  def part2("target area: x=" <> rest) do
    [x_range, y_range] = String.split(rest, ", y=", trim: true)

    [x1, x2] =
      x_range
      |> String.split("..", trim: true)
      |> Enum.map(&String.to_integer/1)

    [y1, y2] =
      y_range
      |> String.split("..", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort(:desc)

    target =
      for(
        x <- x1..x2,
        y <- y1..y2,
        do: {x, y}
      )

    end_point = Enum.at(target, -1)

    start = {0, 0}

    for x <- 0..x2, y <- y2..100 do
      {{x, y}, play_until_hit_or_miss(start, {x, y}, MapSet.new(target), end_point, {0, 0})}
    end
    |> Enum.filter(&(elem(elem(&1, 1), 0) == :hit))
    |> Enum.count()
  end
end
