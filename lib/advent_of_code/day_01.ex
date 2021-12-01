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
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce({0, 9999}, fn n, {acc, prev} ->
      acc =
        if n > prev do
          acc + 1
        else
          acc
        end

      {acc, n}
    end)
    |> elem(0)
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
    inputs =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer(&1))

    count_increments(inputs, 0)
  end

  defp count_increments([a, b, c, d | rest], n)
       when a + b + c < b + c + d,
       do: count_increments([b, c, d | rest], n + 1)

  defp count_increments([_a, b, c, d | rest], n),
    do: count_increments([b, c, d | rest], n)

  defp count_increments(_, n), do: n
end
