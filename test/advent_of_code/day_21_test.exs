defmodule AdventOfCode.Day21Test do
  use ExUnit.Case

  import AdventOfCode.Day21

  # @tag :skip
  test "part1" do
    input = """
    Player 1 starting position: 4
    Player 2 starting position: 8
    """

    result = part1(input)

    assert result == 739_785
  end

  @tag :skip
  test "part2" do
    input = """
    Player 1 starting position: 4
    Player 2 starting position: 8
    """

    result = part2(input)

    # assert %{
    #          1 => %{4 => 1, 5 => 3, 6 => 6, 7 => 7, 8 => 6, 9 => 3, 10 => 1},
    #          2 => %{1 => 1, 5 => 1, 6 => 3, 7 => 6, 8 => 7, 9 => 6, 10 => 3},
    #          3 => %{1 => 3, 2 => 1, 6 => 1, 7 => 3, 8 => 6, 9 => 7, 10 => 6},
    #          4 => %{1 => 6, 2 => 3, 3 => 1, 7 => 1, 8 => 3, 9 => 6, 10 => 7},
    #          5 => %{1 => 7, 2 => 6, 3 => 3, 4 => 1, 8 => 1, 9 => 3, 10 => 6},
    #          6 => %{1 => 6, 2 => 7, 3 => 6, 4 => 3, 5 => 1, 9 => 1, 10 => 3},
    #          7 => %{1 => 3, 2 => 6, 3 => 7, 4 => 6, 5 => 3, 6 => 1, 10 => 1},
    #          8 => %{1 => 1, 2 => 3, 3 => 6, 4 => 7, 5 => 6, 6 => 3, 7 => 1},
    #          9 => %{2 => 1, 3 => 3, 4 => 6, 5 => 7, 6 => 6, 7 => 3, 8 => 1},
    #          10 => %{3 => 1, 4 => 3, 5 => 6, 6 => 7, 7 => 6, 8 => 3, 9 => 1}
    #        } == result

    assert result == 444_356_092_776_315
  end
end
