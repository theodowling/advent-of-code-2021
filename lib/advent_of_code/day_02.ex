defmodule AdventOfCode.Day02 do
  def part1(text) do
    text
    |> String.split("\n", trim: true)
    |> parse_lines1({0, 0})
  end

  def part2(text) do
    text
    |> String.split("\n", trim: true)
    |> parse_lines2({0, 0, 0})
  end

  defp parse_lines1([], {x, y}), do: x * y

  defp parse_lines1([head | tail], {x, y}) do
    parse_lines1(tail, update_coordinates1(head, {x, y}))
  end

  defp update_coordinates1(<<"forward ", a::binary>>, {x, y}) do
    {x + String.to_integer(a), y}
  end

  defp update_coordinates1(<<"down ", a::binary>>, {x, y}) do
    {x, y + String.to_integer(a)}
  end

  defp update_coordinates1(<<"up ", a::binary>>, {x, y}) do
    {x, y - String.to_integer(a)}
  end

  defp parse_lines2([], {x, y, _z}), do: x * y

  defp parse_lines2([head | tail], {x, y, z}) do
    parse_lines2(tail, update_coordinates2(head, {x, y, z}))
  end

  defp update_coordinates2(<<"forward ", a::binary>>, {x, y, z}) do
    {x + String.to_integer(a), y + String.to_integer(a) * z, z}
  end

  defp update_coordinates2(<<"down ", a::binary>>, {x, y, z}) do
    {x, y, z + String.to_integer(a)}
  end

  defp update_coordinates2(<<"up ", a::binary>>, {x, y, z}) do
    {x, y, z - String.to_integer(a)}
  end
end
