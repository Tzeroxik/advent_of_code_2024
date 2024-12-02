import util
import gleam/list
import gleam/result
import gleam/string
import gleam/int
import gleam/option.{type Option, Some, None}

pub fn run(file_path: String) {
  let assert Ok(lines) = util.read_file_lines(file_path) 
  let assert Ok(levels) = 
    list.map(lines, fn (line) { string.split(line," ") |> list.map(int.parse) |> result.all })
    |> result.all
  
  let part1 = list.count(levels, is_stable(_, None))
  let part2 = list.count(levels, is_stable_dropping_one_unstable)
  #(part1, part2)
} 

type LevelPattern {
  Asc
  Desc
}

fn is_stable_dropping_one_unstable(line: List(Int)) {
  case is_stable(line, None) {
    True -> True
    _    -> get_sub_sequences(line, 0, []) |> list.any(is_stable(_, None))
  }
}

fn get_sub_sequences(line: List(Int), idx: Int, acc: List(List(Int))) {
  case idx < list.length(line) {
    False -> acc
    True -> {
      let assert #(lhs, [_, ..rest]) = list.split(line, idx)
      let seq = list.append(lhs, rest)
      [seq, ..acc] |> get_sub_sequences(line, idx + 1, _)

    }
  }
}

fn is_stable(line: List(Int), acc: Option(LevelPattern)) {
  case line {
    [a,b, ..rest] if a > b && a - b <= 3 && acc != Some(Asc)  -> is_stable([b, ..rest], Some(Desc))
    [a,b, ..rest] if a < b && b - a <= 3 && acc != Some(Desc) -> is_stable([b, ..rest], Some(Asc))
    [_] -> True
    _   -> False
  }
}
