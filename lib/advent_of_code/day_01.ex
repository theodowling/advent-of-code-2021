defmodule AdventOfCode.Day01 do
  @spec part1(any) :: integer
  @doc """

      iex> part1(\"""
      ...> 199
      ...> 200
      ...> 208
      ...> 210
      ...> 200
      ...> 207
      ...> 240
      ...> 269
      ...> 260
      ...> 263
      ...> \""")
      7
  """
  def part1(args) do
    {count, _} =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer(&1))
      |> Enum.reduce({0, 9999}, fn n, {acc, prev} ->
        acc =
          if n > prev do
            acc + 1
          else
            acc
          end

        {acc, n}
      end)

    count
  end

  @doc """

      iex> part2(\"""
      ...> 199
      ...> 200
      ...> 208
      ...> 210
      ...> 200
      ...> 207
      ...> 240
      ...> 269
      ...> 260
      ...> 263
      ...> \""")
      5
  """

  def part2(args) do
    [a, b, c | rest] =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer(&1))

    Enum.reduce(rest, {{a, b, c}, 0}, fn n, {{a, b, c}, acc} ->
      if a + b + c < b + c + n do
        {{b, c, n}, acc + 1}
      else
        {{b, c, n}, acc}
      end
    end)
    |> elem(1)
  end
end
