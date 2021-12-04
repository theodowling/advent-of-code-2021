defmodule AdventOfCode.Day03 do
  @spec part1(binary()) :: integer()
  def part1(input) do
    lines =
      input
      |> String.split("\n", trim: true)

    number_inputs = length(lines)
    binary_length = String.length(List.first(lines))
    half = div(number_inputs, 2)

    gamma =
      lines
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.reduce(%{}, fn binary, acc ->
        binary
        |> Enum.with_index(1)
        |> Enum.reduce(acc, fn {b, n}, a ->
          if b == "1", do: Map.update(a, n, 1, &(&1 + 1)), else: a
        end)
      end)
      |> Enum.map(fn {_k, v} ->
        if(v > half, do: 1, else: 0)
      end)

    <<epsilon::size(binary_length)>> =
      Enum.map(gamma, fn x -> if x == 1, do: 0, else: 1 end)
      |> Enum.into(<<>>, fn bit -> <<bit::1>> end)

    <<gamma::size(binary_length)>> = Enum.into(gamma, <<>>, fn bit -> <<bit::1>> end)

    gamma * epsilon
  end

  @spec part2(binary) :: integer
  def part2(input) do
    lines =
      input
      |> String.split("\n", trim: true)

    # number_inputs = length(lines)
    # binary_length = String.length(List.first(lines))
    # half = div(number_inputs, 2)

    lines
    |> Enum.map(&to_charlist/1)
    |> life_support_rating
  end

  def life_support_rating(list) when is_list(list) do
    o2_rating(list) * co2_rating(list)
  end

  def o2_rating(list) when is_list(list) do
    reduce_list(list, fn numbers_with_zero, numbers_with_one ->
      if Enum.count(numbers_with_zero) > Enum.count(numbers_with_one) do
        numbers_with_zero
      else
        numbers_with_one
      end
    end)
  end

  def co2_rating(list) when is_list(list) do
    reduce_list(list, fn numbers_with_zero, numbers_with_one ->
      if Enum.count(numbers_with_zero) > Enum.count(numbers_with_one) do
        numbers_with_one
      else
        numbers_with_zero
      end
    end)
  end

  defp reduce_list([number | _] = list, fun) when is_function(fun, 2) do
    binary_length = length(number)

    0..binary_length
    |> Enum.reduce(list, fn
      _index, [number] ->
        [number]

      index, numbers ->
        {numbers_with_zero, numbers_with_one} =
          Enum.split_with(numbers, fn number -> Enum.at(number, index) === ?0 end)

        fun.(numbers_with_zero, numbers_with_one)
    end)
    |> Enum.at(0)
    |> to_string()
    |> String.to_integer(2)
  end
end
