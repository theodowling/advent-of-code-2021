defmodule Mix.Tasks.D01.P2 do
  use Mix.Task

  import AdventOfCode.Day01

  @shortdoc "Day 01 Part 2"
  def run(args) do
    input = AdventOfCode.Input.get!(1)

    if Enum.member?(args, "-b"),
      do:
        Benchee.run(%{
          part_1: fn -> input |> part1() end,
          part_2: fn -> input |> part2() end,
          combined: fn -> {part1(input), part2(input)} end
        }),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
