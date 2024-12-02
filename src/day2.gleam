import gleam/int
import gleam/list
import gleam/result
import gleam/string
import util

pub fn run(file_path: String) {
  let assert Ok(lines) = util.read_file_lines(file_path)
  let assert Ok(levels) =
    list.map(lines, fn(line) {
      line
      |> string.split(" ")
      |> list.map(int.parse)
      |> result.all
    })
    |> result.all

  let part1 = list.count(levels, is_stable)
  let part2 = list.count(levels, is_stable_dropping_one_unstable)
  #(part1, part2)
}

type LevelPattern {
  Asc
  Desc
  None
}

fn is_stable_dropping_one_unstable(line: List(Int)) {
  case is_stable(line) {
    True -> True
    False ->
      line
      |> list.length
      |> int.subtract(1)
      |> list.combinations(line, _)
      |> list.any(is_stable)
  }
}

fn is_stable(line: List(Int)) {
  do_is_stable(line, None)
}

fn do_is_stable(line: List(Int), acc: LevelPattern) {
  case line {
    [a, b, ..rest] -> {
      let pattern = case acc {
        Asc | None if a > b && a - b <= 3 -> Asc
        Desc | None if a < b && b - a <= 3 -> Desc
        _ -> None
      }
      case pattern {
        None -> False
        pattern -> do_is_stable([b, ..rest], pattern)
      }
    }
    [_] -> True
    _ -> False
  }
}
