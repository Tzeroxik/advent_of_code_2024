import util
import gleam/list
import gleam/result
import gleam/string
import gleam/int
import gleam/option.{type Option, Some, None}

pub fn run(file_path: String) {
  let assert Ok(lines) = util.read_file_lines(file_path) 
  lines 
  |> list.map(string.split(_, on: " "))   
  |> list.count(is_stable)
} 

type LevelPattern {
  Asc
  Desc
}

fn is_stable(levels: List(String)) {
  let assert Ok(levels_int) = list.map(levels, int.parse) |> result.all
  do_is_stable(levels_int, None)
} 

fn do_is_stable(levels: List(Int), acc: Option(LevelPattern)) {
  case levels {
    [a,b, ..rest] if a > b && a - b <= 3 && acc != Some(Asc) -> do_is_stable([b, ..rest], Some(Desc))
    [a,b, ..rest] if a < b && b - a <= 3 && acc != Some(Desc) -> do_is_stable([b, ..rest], Some(Asc))
    [_] -> True
    _   -> False
  }
}
