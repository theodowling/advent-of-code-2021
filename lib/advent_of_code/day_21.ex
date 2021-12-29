defmodule AdventOfCode.Day21 do
  def part1(input) do
    [_, a, _, b] = input |> String.split(["\n", ": "], trim: true)
    p1_pos = String.to_integer(a)
    p2_pos = String.to_integer(b)

    rolls = 1..100 |> Stream.cycle() |> Stream.chunk_every(3, 3, :discard) |> Enum.take(400)
    play(rolls, p1_pos, p2_pos, 1, {0, 0}, 0)
  end

  def play([], _, _, _, a, b), do: {:no_winner, a, b}

  def play(_, _, _, _, {p1, p2}, count) when p1 >= 1000 do
    p2 * count * 3
  end

  def play(_, _, _, _, {p1, p2}, count) when p2 >= 1000 do
    p1 * count * 3
  end

  def play([roll | rolls], p1_pos, p2_pos, 1, {p1_score, p2_score}, count) do
    new_pos = move(roll, p1_pos)
    play(rolls, new_pos, p2_pos, 2, {p1_score + new_pos, p2_score}, count + 1)
  end

  def play([roll | rolls], p1_pos, p2_pos, 2, {p1_score, p2_score}, count) do
    new_pos = move(roll, p2_pos)
    play(rolls, p1_pos, new_pos, 1, {p1_score, p2_score + new_pos}, count + 1)
  end

  def move(roll, pos) do
    roll
    |> Enum.sum()
    |> then(&(&1 + pos))
    |> determine_position()
  end

  def determine_position(a) when a <= 10, do: a
  def determine_position(a) when rem(a, 10) == 0, do: 10
  def determine_position(a), do: rem(a, 10)

  def part2(input) do
    # Enum.map(1..10, fn pos ->
    #   freqs =
    #     for a <- 1..3, b <- 1..3, c <- 1..3 do
    #       determine_position(pos + a + b + c)
    #     end
    #     |> Enum.frequencies()

    #   {pos, freqs}
    # end)
    # |> Enum.into(%{})

    dice =
      for i <- 1..3, j <- 1..3, k <- 1..3 do
        i + j + k
      end
      |> Enum.frequencies()

    [_, a, _, b] = input |> String.split(["\n", ": "], trim: true)
    p1_pos = String.to_integer(a)
    p2_pos = String.to_integer(b)

    {{p1_pos, 0}, {p2_pos, 0}}
    |> play(dice)
    |> Tuple.to_list()
    |> Enum.max()
  end

  def play({{p1, s1}, {p2, s2}}, dice) do
    if s2 >= 21 do
      {0, 1}
    else
      for {d, n} <- dice, reduce: {0, 0} do
        {w1, w2} ->
          p = rem(p1 + d - 1, 10) + 1
          {v2, v1} = play({{p2, s2}, {p, s1 + p}}, dice)
          {w1 + v1 * n, w2 + v2 * n}
      end
    end
  end
end
