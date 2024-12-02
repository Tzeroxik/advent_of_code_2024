import simplifile.{type FileError, read}
import gleam/result
import gleam/string.{trim, split, replace}
import gleam/list

pub fn read_file_lines(file_path: String) -> Result(List(String), FileError) {
  file_path 
  |> read
  |> result.map(fn (str) { str |> trim |> split("\n") |> list.map(replace(_,"\r", "")) })
}
