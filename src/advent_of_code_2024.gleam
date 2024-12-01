import gleam/io
import day1

pub fn main() {
  io.println("Hello from advent_of_code_2024!")
  day1.run("input/day1.txt") |> io.debug
}
