defmodule Mix.Tasks.D02.P2 do
  use Mix.Task

  import AdventOfCode.Day02

  @shortdoc "Day 02 Part 2"
  def run(args) do
    input = AdventOfCode.Input.get!(2)

    if Enum.member?(args, "-b"),
      do:
        Benchee.run(%{
          part_1: fn -> input |> part2() end,
          part_2: fn -> input |> part2() end,
          combined: fn -> part2(input) + part1(input) end
        }),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
