defmodule AdventOfCode.Day12Test do
  use ExUnit.Case

  import AdventOfCode.Day12

  # @tag :skip
  test "part1" do
    input = """
    start-A
    start-b
    A-c
    A-b
    b-d
    A-end
    b-end
    """

    result = part1(input)

    assert result == 10
  end

  # @tag :skip
  test "part2" do
    input = """
    dc-end
    HN-start
    start-kj
    dc-start
    dc-HN
    LN-dc
    HN-end
    kj-sa
    kj-HN
    kj-dc
    """

    result = part2(input)

    assert result == 103
  end
end
