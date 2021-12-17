defmodule AdventOfCode.Day15 do
  alias Graph.Edge

  def part1(input) do
    maps =
      input
      |> String.split("\n", trim: true)
      |> Enum.with_index(1)
      |> Enum.map(fn {line, y} ->
        line
        |> String.codepoints()
        |> Enum.map(&String.to_integer(&1))
        |> Enum.with_index(1)
        |> Enum.map(fn {v, x} ->
          {{x, y}, v}
        end)
      end)
      |> List.flatten()
      |> Enum.into(%{})

    keys = Map.keys(maps)
    g = Graph.new() |> Graph.add_vertices(keys)
    n = keys |> length() |> :math.sqrt() |> trunc()

    edges =
      maps
      |> Enum.reduce([], fn {b, v}, acc ->
        edges =
          b
          |> neighbours(n, n)
          |> Enum.map(fn a ->
            Edge.new(b, a, weight: v)
          end)

        edges ++ acc
      end)

    g
    |> Graph.add_edges(edges)
    |> Graph.dijkstra({1, 1}, {n, n})
    |> Enum.filter(fn a -> a != {1, 1} end)
    |> Enum.map(&Map.get(maps, &1))
    |> Enum.sum()
  end

  def part2(input) do
    lines =
      input
      |> String.split("\n", trim: true)

    n = Enum.count(lines)

    maps =
      lines
      |> Enum.with_index(1)
      |> Enum.map(fn {line, y} ->
        line
        |> String.codepoints()
        |> Enum.map(&String.to_integer(&1))
        |> Enum.with_index(1)
        |> Enum.map(fn {v, x} ->
          for m1 <- 0..4,
              m2 <- 0..4 do
            {{x + m1 * n, y + m2 * n}, wrap_around(v, m1, m2)}
          end
        end)
      end)
      |> List.flatten()
      |> Enum.into(%{})

    n = n * 5

    graph =
      Graph.new(
        vertex_identifier: fn
          {x, y} -> y * n + x
          n -> n
        end
      )

    graph =
      maps
      |> Enum.reduce(graph, fn {a, v}, acc ->
        a
        |> neighbours(n, n)
        |> Enum.reduce(acc, fn b, acc ->
          Graph.add_edge(acc, a, b, weight: v)
        end)
      end)

    # graph =
    #   graph
    #   |> Graph.edges()
    #   |> Enum.reduce(graph, fn %Graph.Edge{v1: {x1, y1}, v2: {x2, y2}}, acc ->
    #     if x1 != x2 and y1 != y2 do
    #       Graph.delete_edge(acc, {x1, y1}, {x2, y2})
    #     else
    #       acc
    #     end
    #   end)

    # |> IO.inspect()

    # IO.inspect(Graph.out_edges(graph, {69, 18}), label: "out edges")
    # IO.inspect(Graph.in_edges(graph, {332, 404}), label: "in edges")

    IO.inspect(graph)

    graph
    |> Graph.dijkstra({1, 1}, {n, n})
    # |> tap(fn x -> Enum.each(x, &IO.puts(inspect(&1))) end)
    |> IO.inspect()
    |> Enum.filter(fn a -> a != {1, 1} end)
    |> Enum.map(&Map.get(maps, &1))
    |> Enum.sum()
  end

  # 1190 is too low
  # 1325
  # 2874 is answer for someone else

  def wrap_around(v, m1, m2) do
    k = v + m1 + m2
    if k < 10, do: k, else: k - 9
  end

  def neighbours({x, y}, max_x, max_y) do
    [
      {x + 1, y},
      {x, y + 1},
      {x, y - 1},
      {x - 1, y}
    ]
    |> Enum.filter(fn {vx, vy} -> vx >= 1 and vx <= max_x and vy >= 1 and vy <= max_y end)
  end
end
