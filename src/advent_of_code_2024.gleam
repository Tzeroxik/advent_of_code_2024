import day1
import day2
import day3
import gleam/io

pub fn main() {
  io.println("Hello from Advent of Code 2024!")
  day1.run("./input/day1.txt") |> io.debug
  day2.run("./input/day2.txt") |> io.debug
  day3.run("./input/day3.txt") |> io.debug
}
