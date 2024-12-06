defmodule Util do
  def load_input!(day_number) when is_number(day_number) do
    File.read!("inputs/day#{day_number}.txt")
  end

  defmodule Result do
    defstruct [:day, :part1, :part2]
  end

  def split_lines(str) do
    str |> String.trim() |> String.split(~r{(\r\n|\r|\n)})
  end

  def run_day!(day_number, runner) when is_number(day_number) and is_function(runner) do
    {p1, p2} = load_input!(day_number) |> runner.()
    %Result{day: day_number, part1: p1, part2: p2} |> IO.inspect()
  end
end
