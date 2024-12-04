defmodule Util do
  def load_input!(day_number) when is_number(day_number) do
    File.read!("inputs/day#{day_number}.txt")
  end

  def run_day!(day_number, runner) when is_number(day_number) and is_function(runner) do
    load_input!(day_number) |> runner.()
  end
end
