import gleam/list
import gleam/result
import gleam/string.{replace, split, trim}
import simplifile.{type FileError, read}

pub fn read_file_lines(file_path: String) -> Result(List(String), FileError) {
  file_path
  |> read_file_as_str
  |> result.map(fn(str) {
    str |> trim |> split("\n") |> list.map(replace(_, "\r", ""))
  })
}

pub fn read_file_as_str(file_path: String) -> Result(String, FileError) {
  file_path |> read
}
