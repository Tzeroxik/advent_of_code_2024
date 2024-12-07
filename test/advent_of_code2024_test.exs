defmodule AdventOfCode2024Test do
  use ExUnit.Case

  test "RUN DAYS" do
    Util.run_day!(4, &Day4.run!/1)
    # Util.run_day!(5, &Day5.run!/1)
    Util.run_day!(7, &Day7.run!/1)
  end
end
