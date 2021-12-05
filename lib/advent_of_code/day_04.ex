defmodule AdventOfCode.Day04 do
  def part1(input) do
    [numbers | boards] =
      input
      |> String.split("\n", trim: true)

    numbers =
      numbers
      |> String.split(",", trim: true)

    boards =
      boards
      |> Enum.chunk_every(5)
      |> Enum.with_index()
      |> Enum.map(fn {v, k} -> {k, v} end)

    sets = get_rows_and_diagonals(boards, %{})

    {winning_line, sets, number} = play_till_bingo(numbers, sets)

    {board_nr, _} = winning_line

    sum_missing_numbers =
      sets
      |> Enum.reduce(MapSet.new(), fn {{k_nr, _}, v}, acc ->
        if k_nr == board_nr do
          MapSet.union(acc, v)
        else
          acc
        end
      end)
      |> MapSet.to_list()
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()

    sum_missing_numbers * String.to_integer(number)
  end

  defp get_rows_and_diagonals([], acc), do: acc

  defp get_rows_and_diagonals([{number, board} | rest], acc) do
    rows =
      board
      |> Enum.map(&extract_row_values/1)

    columns =
      0..4
      |> Enum.map(fn i ->
        Enum.map(rows, fn row ->
          Enum.at(row, i)
        end)
      end)

    row_maps = convert_to_map_with_mapsets(rows, number, "r")
    col_maps = convert_to_map_with_mapsets(columns, number, "c")

    acc = Map.merge(acc, Map.merge(row_maps, col_maps))
    get_rows_and_diagonals(rest, acc)
  end

  defp extract_row_values(
         <<a::binary-size(2), " ", b::binary-size(2), " ", c::binary-size(2), " ",
           d::binary-size(2), " ", e::binary-size(2)>>
       ) do
    [String.trim(a), String.trim(b), String.trim(c), String.trim(d), String.trim(e)]
  end

  defp convert_to_map_with_mapsets(input, number, char) do
    input
    |> Enum.with_index()
    |> Enum.map(fn {v, k} ->
      {{number, "#{char}#{k}"}, MapSet.new(v)}
    end)
    |> Enum.into(%{})
  end

  defp play_till_bingo([number | rest], sets) do
    update =
      sets
      |> Enum.reduce(%{}, fn {k, v}, acc ->
        Map.put(acc, k, MapSet.delete(v, number))
      end)

    case Enum.find(update, fn {_k, v} -> MapSet.size(v) == 0 end) do
      {k, _} -> {k, update, number}
      nil -> play_till_bingo(rest, update)
    end
  end

  def part2(input) do
    [numbers | boards] =
      input
      |> String.split("\n", trim: true)

    numbers =
      numbers
      |> String.split(",", trim: true)

    boards =
      boards
      |> Enum.chunk_every(5)
      |> Enum.with_index()
      |> Enum.map(fn {v, k} -> {k, v} end)

    board_numbers = Enum.count(boards) - 1

    sets = get_rows_and_diagonals(boards, %{})

    {sets, number} = play_till_last_board_bingo(numbers, sets, Enum.to_list(0..board_numbers))

    sum_missing_numbers =
      sets
      |> Enum.map(fn {_, v} -> MapSet.to_list(v) end)
      |> List.flatten()
      |> Enum.uniq()
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()

    sum_missing_numbers * String.to_integer(number)
  end

  defp remove_boards_where_there_has_been_bingo(sets, w) do
    sets
    |> Map.delete({w, "r0"})
    |> Map.delete({w, "c0"})
    |> Map.delete({w, "r1"})
    |> Map.delete({w, "c1"})
    |> Map.delete({w, "r2"})
    |> Map.delete({w, "c2"})
    |> Map.delete({w, "r3"})
    |> Map.delete({w, "c3"})
    |> Map.delete({w, "r4"})
    |> Map.delete({w, "c4"})
  end

  defp play_till_last_board_bingo([number | rest], sets, boards_remaining) do
    new_sets =
      sets
      |> Enum.reduce(%{}, fn {k, v}, acc ->
        Map.put(acc, k, MapSet.delete(v, number))
      end)

    winners =
      Enum.reduce(new_sets, [], fn {{k, _}, v}, acc ->
        if MapSet.size(v) == 0 do
          [k] ++ acc
        else
          acc
        end
      end)
      |> Enum.uniq()

    case Enum.count(winners) == Enum.count(boards_remaining) do
      true ->
        {new_sets, number}

      false ->
        {boards_remaining, sets} =
          Enum.reduce(winners, {boards_remaining, new_sets}, fn w, {boards, sets} ->
            {List.delete(boards, w), remove_boards_where_there_has_been_bingo(sets, w)}
          end)

        play_till_last_board_bingo(rest, sets, boards_remaining)
    end
  end
end
