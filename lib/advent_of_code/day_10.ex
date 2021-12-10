defmodule AdventOfCode.Day10 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.codepoints()
      |> valid_line?()
    end)
    |> Enum.reduce(0, fn
      {:error, ")", _}, acc ->
        acc + 3

      {:error, "]", _}, acc ->
        acc + 57

      {:error, "}", _}, acc ->
        acc + 1197

      {:error, ">", _}, acc ->
        acc + 25137

      {:ok, _}, acc ->
        acc
    end)
  end

  def valid_line?(line), do: valid_line?(line, 0, 0, 0, 0, [])

  def valid_line?([], _, _, _, _, e), do: {:ok, e}

  def valid_line?(["(" | line], a, b, c, d, state),
    do: valid_line?(line, a + 1, b, c, d, [:a | state])

  def valid_line?(["[" | line], a, b, c, d, state),
    do: valid_line?(line, a, b + 1, c, d, [:b | state])

  def valid_line?(["{" | line], a, b, c, d, state),
    do: valid_line?(line, a, b, c + 1, d, [:c | state])

  def valid_line?(["<" | line], a, b, c, d, state),
    do: valid_line?(line, a, b, c, d + 1, [:d | state])

  def valid_line?([")" | _line], a, _, _, _, _) when a < 1, do: {:error, ")", "out of bounds"}
  def valid_line?(["]" | _line], _, b, _, _, _) when b < 1, do: {:error, "]", "out of bounds"}
  def valid_line?(["}" | _line], _, _, c, _, _) when c < 1, do: {:error, "}", "out of bounds"}
  def valid_line?([">" | _line], _, _, _, d, _) when d < 1, do: {:error, ">", "out of bounds"}

  def valid_line?([")" | line], a, b, c, d, [:a | state]),
    do: valid_line?(line, a - 1, b, c, d, state)

  def valid_line?(["]" | line], a, b, c, d, [:b | state]),
    do: valid_line?(line, a, b - 1, c, d, state)

  def valid_line?(["}" | line], a, b, c, d, [:c | state]),
    do: valid_line?(line, a, b, c - 1, d, state)

  def valid_line?([">" | line], a, b, c, d, [:d | state]),
    do: valid_line?(line, a, b, c, d - 1, state)

  def valid_line?([a | _], _, _, _, _, [b | _]), do: {:error, a, "expected #{b}"}

  def part2(input) do
    all_ordered =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.codepoints()
        |> valid_line?()
      end)
      |> Enum.filter(&(elem(&1, 0) === :ok))
      |> Enum.map(&calculate_prize(elem(&1, 1), 0))
      |> Enum.sort()

    Enum.at(all_ordered, div(length(all_ordered), 2))
  end

  def calculate_prize([], acc), do: acc

  def calculate_prize([:a | next], acc), do: calculate_prize(next, acc * 5 + 1)
  def calculate_prize([:b | next], acc), do: calculate_prize(next, acc * 5 + 2)
  def calculate_prize([:c | next], acc), do: calculate_prize(next, acc * 5 + 3)
  def calculate_prize([:d | next], acc), do: calculate_prize(next, acc * 5 + 4)
end
