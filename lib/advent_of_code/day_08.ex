defmodule AdventOfCode.Day08 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " | ", trim: true))
    |> Enum.map(fn [_, b] ->
      # {
      # String.split(a, " ", trim: true),
      String.split(b, " ", trim: true)
      # }
    end)
    |> Enum.map(fn outputs ->
      outputs
      |> Enum.filter(&(byte_size(&1) in [2, 3, 4, 7]))
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&decode_output/1)
    |> Enum.sum()
  end

  @doc """

      iex> decode_output("acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf")
      5353

  """

  def decode_output(line) do
    [input, output] =
      line
      |> String.split(" | ", trim: true)
      |> Enum.map(&String.split(&1, " ", trim: true))

    code =
      input
      |> List.flatten(output)
      |> Enum.map(fn code ->
        code
        |> String.split("", trim: true)
        |> MapSet.new()
      end)
      |> Enum.uniq()
      |> Enum.group_by(&MapSet.size(&1))
      |> decern_digits()

    output
    |> decode(code)
  end

  def decern_digits(input) do
    %{2 => [i1], 3 => [i7], 4 => [i4], 5 => g5, 6 => g6, 7 => [i8]} = input

    [_da] = MapSet.difference(i7, i1) |> MapSet.to_list()

    # determine 3 and 9
    i3 = g5 |> Enum.find(&MapSet.subset?(i1, &1))
    i9 = g6 |> Enum.find(&MapSet.subset?(i3, &1))

    [db] = MapSet.difference(i9, i3) |> MapSet.to_list()

    [de] =
      MapSet.difference(MapSet.new(["a", "b", "c", "d", "e", "f", "g"]), i9) |> MapSet.to_list()

    i2 = g5 |> Enum.find(&MapSet.member?(&1, de))
    i5 = g5 |> Enum.find(&MapSet.member?(&1, db))

    g6 = List.delete(g6, i9)

    i6 = g6 |> Enum.find(&MapSet.subset?(i5, &1))

    [i0] = g6 |> List.delete(i6)

    [
      {i1, "1"},
      {i2, "2"},
      {i3, "3"},
      {i4, "4"},
      {i5, "5"},
      {i6, "6"},
      {i7, "7"},
      {i8, "8"},
      {i9, "9"},
      {i0, "0"}
    ]
    |> Enum.into(%{})
  end

  def decode(output, code) do
    output
    |> Enum.map(fn digit ->
      lookup = digit |> String.split("", trim: true) |> MapSet.new()
      Map.get(code, lookup)
    end)
    |> Enum.join()
    |> String.to_integer()
  end
end
