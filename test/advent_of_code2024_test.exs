defmodule AdventOfCode2024Test do
  use ExUnit.Case
  doctest AdventOfCode2024

  test "day 4" do
    Util.run_day!(4, &AdventOfCode2024.day4!/1) |> IO.inspect
  end

  test "util reads from inputs folder" do
    assert Util.load_input!(0) == "ok"
  end
end
