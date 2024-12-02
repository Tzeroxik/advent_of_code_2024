import gleam/io
import day1
import day2

pub fn main() {
  io.println("Hello from advent_of_code_2024!")
  day1.run("./input/day1.txt") |> io.debug
  day2.run("./input/day2.txt") |> io.debug
}
