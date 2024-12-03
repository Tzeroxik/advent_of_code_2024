import gleam/int
import gleam/list
import gleam/option
import gleam/regexp.{type Match}
import util

pub fn run(input_path: String) {
  let assert Ok(input) = util.read_file_as_str(input_path)
  let capture_mul = "mul\\((\\d{1,3}),(\\d{1,3})\\)"

  let assert Ok(regex) = regexp.from_string(capture_mul)

  let part1 =
    regexp.scan(regex, input)
    |> list.map(mul_sub_matches)
    |> list.fold(0, int.add)

  let assert Ok(regex_improved) = regexp.from_string("don't|do|" <> capture_mul)

  let part2 =
    regexp.scan(regex_improved, input)
    |> mul_reduce

  #(part1, part2)
}

fn mul_reduce(matches: List(Match)) -> Int {
  do_mul_reduce(matches, 0, True)
}

fn do_mul_reduce(matches: List(Match), total: Int, do: Bool) -> Int {
  case matches {
    [] -> total
    [match, ..rest] ->
      case match.content {
        "do" -> do_mul_reduce(rest, total, True)
        "don't" -> do_mul_reduce(rest, total, False)
        _ if do == False -> do_mul_reduce(rest, total, do)
        _ ->
          match
          |> mul_sub_matches
          |> int.add(total)
          |> do_mul_reduce(rest, _, do)
      }
  }
}

fn mul_sub_matches(match: Match) -> Int {
  match.submatches
  |> list.map(option.unwrap(_, "0"))
  |> list.filter_map(int.parse)
  |> list.fold(1, int.multiply)
}
