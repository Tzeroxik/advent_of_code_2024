import simplifile.{type FileError, read}
import gleam/result
import gleam/string.{trim, split}

pub fn read_file_lines(file_path: String) -> Result(List(String), FileError) {
  file_path 
  |> read
  |> result.map(fn (str) { str |> trim |> split("\n")})
}
