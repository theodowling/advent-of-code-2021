defmodule AdventOfCode.Day16Test do
  use ExUnit.Case

  import AdventOfCode.Day16

  @tag :skip
  test "part1" do
    input = "D2FE28"
    assert parse_input(input) == [%{number: 2021, type: :literal, version: 6}]

    assert parse_input("38006F45291200") == [
             %{
               id: 6,
               packets: [
                 %{number: 10, type: :literal, version: 6},
                 %{number: 20, type: :literal, version: 2}
               ],
               sub_packet_length: 27,
               type: :operator,
               version: 1
             }
           ]

    assert parse_input("EE00D40C823060") == [
             %{
               id: 3,
               packet_numbers: 3,
               packets: [
                 %{number: 1, type: :literal, version: 2},
                 %{number: 2, type: :literal, version: 4},
                 %{number: 3, type: :literal, version: 1}
               ],
               type: :operator,
               version: 7
             }
           ]

    assert part1("8A004A801A8002F478") == 16

    assert part1("620080001611562C8802118E34") == 12

    assert part1("C0015000016115A2E0802F182340") == 23

    assert part1("A0016C880162017C3686B18A3D4780") == 31
  end

  @tag :skip
  test "part2" do
    input = "C200B40A82"
    result = part2(input)

    assert result == 3
  end

  @tag :skip
  test "part2.1" do
    # input = "04005AC33890"
    # result = part2(input)
    # assert result == 54

    # assert part2("880086C3E88112") == 7
    # assert part2("CE00C43D881120") == 9
    # assert part2("D8005AC2A8F0") == 1
    # assert part2("F600BC2D8F") == 0
    # assert part2("9C005AC2F8F0") == 0
    assert part2("9C0141080250320F1802104A08") == 1
  end
end
