defmodule Day4 do
  def run!(input) when not is_nil(input) do
    array = convert_to_array(input)
    matches = find_pattern(<<"XMAS">>, array)
    part1 = matches

    {part1}
  end

  def find_pattern(pattern, array) do
    pattern_char_list = String.to_charlist(pattern)
    size = array2d_size(array)
    index = {0,0}
    do_find_pattern(pattern_char_list, array, size, index, 0)
  end

  defp do_find_pattern(pattern, array, size, index, matches) do
    {row_size, col_size} = size
    {r, c} = index

    new_matches = matches + extract_patterns(pattern, array, size, index)

    if r == row_size - 1 and c == col_size - 1 do
      new_matches
    else
        new_index = if c == col_size - 1 do {r + 1, 0} else {r, c + 1} end
        do_find_pattern(pattern, array, size, new_index, new_matches)
    end
  end

  defp extract_patterns(pattern, array, size, index) do
    [ {0,1},{0,-1},{1,0},{-1,0},{1,1},{-1,-1},{1,-1},{-1,1}]
    |> Enum.filter(fn direction -> is_pattern(array, size, index, pattern, direction) end)
    |> Enum.count
  end

  defp is_pattern(_, _, _, [], _), do: true
  defp is_pattern(array, size, index, [char| pattern], direction) do
    {r, c} = index
    cond do
      char == array[r][c] -> case add_bounded(size, index, direction) do
        nil -> false
        new_index -> is_pattern(array, size, new_index, pattern, direction)
      end
      true -> false
    end
  end

  defp array2d_size(array) do
    row_size = Arrays.size(array)
    col_size = case row_size do
      0 -> 0
      _ -> array[0] |> Arrays.size
    end
    {row_size, col_size}
  end

  defp add_bounded({row_size, col_size}, {r, c}, {row_add, col_add}) do
    new_r = r + row_add
    new_c = c + col_add
    if new_r < row_size and new_c < col_size and new_r >= 0 or new_c >= 0 do
      {new_r, new_c}
    end
  end

  def convert_to_array(input) do
    input
    |> String.split(~r{(\r\n|\r|\n)})
    |> Enum.map(fn(line) -> String.to_charlist(line) |> Arrays.new end)
    |> Arrays.new
  end

end
