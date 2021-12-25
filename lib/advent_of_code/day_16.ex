defmodule AdventOfCode.Day16 do
  @decode %{
    "0" => [0, 0, 0, 0],
    "1" => [0, 0, 0, 1],
    "2" => [0, 0, 1, 0],
    "3" => [0, 0, 1, 1],
    "4" => [0, 1, 0, 0],
    "5" => [0, 1, 0, 1],
    "6" => [0, 1, 1, 0],
    "7" => [0, 1, 1, 1],
    "8" => [1, 0, 0, 0],
    "9" => [1, 0, 0, 1],
    "A" => [1, 0, 1, 0],
    "B" => [1, 0, 1, 1],
    "C" => [1, 1, 0, 0],
    "D" => [1, 1, 0, 1],
    "E" => [1, 1, 1, 0],
    "F" => [1, 1, 1, 1]
  }
  def part1(input) do
    input
    |> String.codepoints()
    |> Enum.map(fn x -> @decode[x] end)
    |> List.flatten()
    |> parse_code()
    |> count_versions([])
    |> List.flatten()
    |> Enum.sum()
  end

  def parse_input(input) do
    input
    |> String.codepoints()
    |> Enum.map(fn x -> @decode[x] end)
    |> List.flatten()
    |> parse_code()
  end

  def parse_code(code) do
    case parse_code(code, :infinity) do
      {
        %{type: :literal} = result,
        n,
        remainder
      } ->
        nil
    end
  end

  def parse_code(remainder, _) when length(remainder) < 9, do: []
  def parse_code(code, 0), do: {:ok, [], code}
  # type-id = 4 means it is a literal
  def parse_code([v1, v2, v3, 1, 0, 0 | rest], n) do
    version_number = Integer.undigits([v1, v2, v3], 2)

    chunk_fun = fn element, acc ->
      if length(acc) == 4 do
        [h | _] = acc = Enum.reverse([element | acc])

        if h == 1 do
          {:cont, acc, []}
        else
          {:halt, acc}
        end
      else
        {:cont, [element | acc]}
      end
    end

    after_fun = fn
      [] -> {:cont, []}
      acc -> {:cont, acc, []}
    end

    chunks =
      rest
      |> Enum.chunk_while([], chunk_fun, after_fun)

    {_, remainder} = Enum.split(rest, length(chunks) * 5)

    number =
      chunks
      |> Enum.map(fn [_ | rest] -> rest end)
      |> List.flatten()
      |> Integer.undigits(2)

    {
      %{type: :literal, number: number, version: version_number},
      if(n == :infinity, do: :infinity, else: n - 1),
      remainder
    }
  end

  # sub_packet length
  def parse_code([v1, v2, v3, id1, id2, id3, 0 | rest], n) do
    version_number = Integer.undigits([v1, v2, v3], 2)
    id = Integer.undigits([id1, id2, id3], 2)
    {packet_length, packets} = rest |> Enum.split(15)
    sub_packet_length = Integer.undigits(packet_length, 2)
    {packets, remainder} = Enum.split(packets, sub_packet_length)

    {
      %{
        type: :operator,
        id: id,
        version: version_number,
        sub_packet_length: sub_packet_length,
        packets: nil
      },
      if(n == :infinity, do: :infinity, else: n - 1),
      packets,
      remainder
    }
  end

  def parse_code([v1, v2, v3, id1, id2, id3, 1 | rest], n) do
    version_number = Integer.undigits([v1, v2, v3], 2)
    id = Integer.undigits([id1, id2, id3], 2)
    {packet_number, packets} = rest |> Enum.split(11)
    packet_numbers = Integer.undigits(packet_number, 2)

    {
      %{
        type: :operator,
        id: id,
        version: version_number,
        packet_numbers: packet_numbers,
        packets: nil
      },
      if(n == :infinity, do: :infinity, else: n - 1),
      packets,
      []
    }
  end

  def split_packets(_packets, 0, acc), do: Enum.reverse(acc)

  def split_packets(packets, remaining_length, acc)
      when remaining_length < 22 do
    {p, rest} = Enum.split(packets, remaining_length)
    split_packets(rest, 0, p ++ acc)
  end

  def split_packets(packets, remaining_length, acc) do
    {p, rest} = Enum.split(packets, 11)
    split_packets(rest, remaining_length - 11, p ++ acc)
  end

  def count_versions([], acc) do
    acc
  end

  def count_versions(%{version: version, packets: packets}, acc) do
    count_versions(packets, [version]) ++ acc
  end

  def count_versions([%{version: version, packets: packets} | rest], acc) do
    count_versions(rest, [count_versions(packets, []) | [version | acc]])
  end

  def count_versions([%{version: version} | rest], acc) do
    count_versions(rest, [version | acc])
  end

  def part2(input) do
    input
    |> String.codepoints()
    |> Enum.map(fn x -> @decode[x] end)
    |> List.flatten()
    |> parse_code()
    |> IO.inspect()
    |> prepare()
    |> eval()
  end

  def prepare([a]) do
    prepare(a)
  end

  def prepare(%{id: 0, packets: packets}) when is_list(packets) do
    {:+, Enum.map(packets, &prepare(&1))}
  end

  def prepare(%{id: 1, packets: packets}) when is_list(packets) do
    {:*, Enum.map(packets, &prepare(&1))}
  end

  def prepare(%{id: 2, packets: packets}) when is_list(packets) do
    {:min, Enum.map(packets, &prepare(&1))}
  end

  def prepare(%{id: 3, packets: packets}) when is_list(packets) do
    {:max, Enum.map(packets, &prepare(&1))}
  end

  def prepare(%{type: :literal, number: number}) do
    number
  end

  def prepare(%{id: 5, packets: packets}) when is_list(packets) do
    {:>, Enum.map(packets, &prepare(&1))}
  end

  def prepare(%{id: 6, packets: packets}) when is_list(packets) do
    {:<, Enum.map(packets, &prepare(&1))}
  end

  def prepare(%{id: 7, packets: packets}) when is_list(packets) do
    {:=, Enum.map(packets, &prepare(&1))}
  end

  def prepare(%{id: 7, packets: packets}) do
    p = prepare(packets)
    {:=, p}
  end

  def eval({:+, list}) do
    list |> Enum.map(&eval(&1)) |> Enum.sum()
  end

  def eval({:*, list}) do
    list |> Enum.map(&eval(&1)) |> Enum.product()
  end

  def eval({:min, list}) do
    list |> Enum.map(&eval(&1)) |> Enum.min()
  end

  def eval({:max, list}) do
    list |> Enum.map(&eval(&1)) |> Enum.max()
  end

  def eval({:<, [a, b]}) do
    if eval(a) < eval(b), do: 1, else: 0
  end

  def eval({:>, [a, b]}) do
    if eval(a) > eval(b), do: 1, else: 0
  end

  def eval({:=, [a, b]}) do
    if eval(a) == eval(b), do: 1, else: 0
  end

  def eval(a) when is_number(a), do: a
end
