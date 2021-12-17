# Advent of Code 2021

This include my attempts at solving the advent of code problems for 2021.

## Benchmark results on M1 Macbook Air

```
Name             ips        average  deviation         median         99th %
day_01_pt_1   3.73 K      268.41 μs    ±29.10%         255 μs         457 μs
day_01_pt_2   3.39 K      294.62 μs   ±102.76%         276 μs         546 μs
day_02        3.30 K      303.37 μs     ±9.59%      297.99 μs      406.37 μs
day_03        1.90 K      525.68 μs    ±14.67%         507 μs      816.88 μs
day_04         53.71       18.62 ms     ±2.99%       18.64 ms       19.89 ms
day_05         11.10       90.05 ms     ±8.28%       88.04 ms      107.81 ms
day_06        5.47 K      182.80 μs     ±3.02%         182 μs         205 μs
day_07         12.08       82.81 ms     ±6.11%       84.06 ms       91.78 ms
day_08        249.04        4.02 ms     ±1.30%        4.01 ms        4.15 ms
day_09         67.48       14.82 ms     ±1.81%       14.92 ms       15.41 ms
day_10        3.40 K      294.38 μs     ±7.93%      287.99 μs      392.99 μs
day_11         48.99       20.41 ms     ±9.94%       19.84 ms       29.39 ms
day_12          0.51         1.94 s     ±2.39%         1.93 s         2.00 s
day_13        616.63        1.62 ms     ±1.90%        1.62 ms        1.70 ms
day_14                              part_2 pending
day_15         0.145         6.89 s     ±0.00%         6.89 s         6.89 s
day_16                              part_1 pending
day_17          0.23         4.43 s     ±1.49%         4.43 s         4.48 s

```

## Generated using Advent of Code Elixir Starter kit

A batteries included starter pack for participating in [Advent of Code](https://www.adventofcode.com) using Elixir!

## Usage

There are 25 modules, 25 tests, and 50 mix tasks.

1. Fill in the tests with the example solutions.
1. Write your implementation.
1. Fill in the final problem inputs into the mix task and run `mix d01.p1`!
    - Benchmark your solution by passing the `-b` flag, `mix d01.p1 -b`

```elixir
defmodule AdventOfCode.Day01 do
  def part1(args) do
  end

  def part2(args) do
  end
end
```

```elixir
defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  @tag :skip # Make sure to remove to run your test.
  test "part1" do
    input = nil
    result = part1(input)

    assert result
  end

  @tag :skip # Make sure to remove to run your test.
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
```

```elixir
defmodule Mix.Tasks.D01.P1 do
  use Mix.Task

  import AdventOfCode.Day01

  @shortdoc "Day 01 Part 1"
  def run(args) do
    input = AdventOfCode.Input.get!(1, 2020)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
```

### Optional Automatic Input Retriever

This starter comes with a module that will automatically get your inputs so you
don't have to mess with copy/pasting. Don't worry, it automatically caches your
inputs to your machine so you don't have to worry about slamming the Advent of
Code server. You will need to configure it with your cookie and make sure to
enable it. You can do this by creating a `config/secrets.exs` file containing
the following:

```elixir
use Mix.Config

config :advent_of_code, AdventOfCode.Input,
  allow_network?: true,
  session_cookie: "..." # yours will be longer
```

After which, you can retrieve your inputs using the module:

```elixir
day = 1
year = 2020
AdventOfCode.Input.get!(day, year)
# or just have it auto-detect the current year
AdventOfCode.Input.get!(7)
# and if your input somehow gets mangled and you need a fresh one:
AdventOfCode.Input.delete!(7, 2019)
# and the next time you `get!` it will download a fresh one -- use this sparingly!
```

## Installation

```bash
# clone
$ git clone git@github.com:mhanberg/advent-of-code-elixir-starter.git advent-of-code
$ cd advent-of-code

# Reinitialize your git repo
$ rm -rf .git && rm -rf .github
$ git init
```
### Get started coding with zero configuration

#### Using Visual Studio Code

1. [Install Docker Desktop](https://www.docker.com/products/docker-desktop)
1. Open project directory in VS Code
1. Press F1, and select `Remote-Containers: Reopen in Container...`
1. Wait a few minutes as it pulls image down and builds Dev Conatiner Docker image (this should only need to happen once unless you modify the Dockerfile)
    1. You can see progress of the build by clicking `Starting Dev Container (show log): Building image` that appears in bottom right corner
    1. During the build process it will also automatically run `mix deps.get`
1. Once complete VS Code will connect your running Dev Container and will feel like your doing local development
1. If you would like to use a specific version of Elixir change the `VARIANT` version in `.devcontainer/devcontainer.json`
1. If you would like more information about VS Code Dev Containers check out the [dev container documentation](https://code.visualstudio.com/docs/remote/create-dev-container/?WT.mc_id=AZ-MVP-5003399)

#### Compatible with Github Codespaces
1. If you dont have Github Codespaces beta access, sign up for the beta https://github.com/features/codespaces/signup
1. On GitHub, navigate to the main page of the repository.
1. Under the repository name, use the  Code drop-down menu, and select Open with Codespaces.
1. If you already have a codespace for the branch, click  New codespace.
