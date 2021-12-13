defmodule AdventOfCode.Day11 do
  def part1(input) do
    points =
      for x <- 0..9,
          y <- 0..9,
          do: {x, y}

    input
    |> build_board()
    |> increment(100, 0, points)
  end

  def part2(input) do
    points =
      for x <- 0..9,
          y <- 0..9,
          do: {x, y}

    input
    |> build_board()
    |> increment(-1, 0, points)
  end

  defp build_board(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.codepoints()
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index(0)
    end)
    |> Enum.with_index(0)
    |> Enum.map(fn {line, y} ->
      Enum.map(line, fn {v, x} ->
        {{x, y}, v}
      end)
    end)
    |> List.flatten()
    |> Enum.into(%{})
  end

  def increment(_board, 0, flashes, _points) do
    flashes
  end

  def increment(board, n, flashes, points) do
    {board, flashed_items} = increment_points(board, points)

    reset_board =
      board
      |> reset_board()

    if reset_board |> Map.values() |> Enum.all?(&(&1 == 0)) do
      abs(n)
    else
      increment(reset_board, n - 1, flashes + length(flashed_items), points)
    end
  end

  def increment_points(board, points) do
    Enum.reduce(points, {board, []}, fn point, {board, flashes} ->
      {flash, board} =
        Map.get_and_update(board, point, fn
          9 = current_value ->
            {true, current_value + 1}

          current_value ->
            {false, current_value + 1}
        end)

      if flash do
        neighbours = neighbours(point)

        {board, flashed_items} = increment_points(board, neighbours)
        {board, [point] ++ flashed_items ++ flashes}
      else
        {board, flashes}
      end
    end)
  end

  def neighbours({x, y}, max_x \\ 9, max_y \\ 9) do
    [
      {x + 1, y},
      {x + 1, y + 1},
      {x, y + 1},
      {x, y - 1},
      {x - 1, y},
      {x - 1, y - 1},
      {x + 1, y - 1},
      {x - 1, y + 1}
    ]
    |> Enum.filter(fn {vx, vy} -> vx >= 0 and vx <= max_x and vy >= 0 and vy <= max_y end)
  end

  def reset_board(board) do
    board
    |> Enum.map(fn {{x, y}, v} ->
      if v > 9 do
        {{x, y}, 0}
      else
        {{x, y}, v}
      end
    end)
    |> Enum.into(%{})
  end
end
