import gleam/result
import gleam/list
import gleam/regexp.{type Regexp}
import gleam/int
import gleam/dict
import gleam/option
import util.{read_file_lines}

pub fn run(file_path: String) {
  let assert Ok(lines) = read_file_lines(file_path)
  let assert Ok(pattern) = regexp.from_string("\\s+")
  let #(left, right) = process_lines(#([],[]), lines, pattern)
  
  let part1 = list.zip(left, right) |> list.fold(0, fn(acc, v) { int.absolute_value(v.0 - v.1) + acc})
  
  let inc = fn(opt) { option.map(opt, fn(i){i + 1}) |> option.unwrap(or: 1) }

  let counts = list.fold(right, dict.new(), fn(acc, r){ dict.upsert(acc, r, inc)})
  let part2 = list.fold(left, 0, fn(acc, left_value) { 
    left_value
    |> dict.get(counts, _)
    |> result.map(fn(count){ left_value * count + acc})
    |> result.unwrap(or:acc)
  }) 

  #(part1, part2)
}

fn process_lines(acc: #(List(Int), List(Int)), lines: List(String), pattern: Regexp) {
    case lines {
      [] -> #(list.sort(acc.0, int.compare), list.sort(acc.1, int.compare))
      [line, ..lines] -> {
        let assert Ok([l, r]) = regexp.split(pattern, line) |> list.map(int.parse) |> result.all
        process_lines(#([l, ..acc.0], [r, ..acc.1]), lines, pattern)
      }
    }
}
