defmodule Day4 do
  def run!(input) when not is_nil(input) do
    array = convert_to_indexed_array(input)
    pattern = String.to_charlist("XMAS")
    part1 = count_pattern(pattern, array, :word)

    pattern = String.to_charlist("MAS")

    part2 = count_pattern(pattern, array, :cross)
    {part1, part2}
  end

  defp count_pattern(pattern, array, mode) do
    array
    |> Enum.map(fn line -> count_pattern_in_line(line, pattern, array, mode) end)
    |> Enum.sum()
  end

  defp count_pattern_in_line({line, ridx}, pattern, array, mode) do
    size = array2d_size(array)

    line
    |> Enum.map(fn {elem, cidx} ->
      find_pattern_starting(elem, {ridx, cidx}, pattern, array, size, mode)
    end)
    |> Enum.sum()
  end

  defp find_pattern_starting(elem, position, pattern, array, size, :word) do
    [{0, 1}, {0, -1}, {1, 0}, {-1, 0}, {1, 1}, {-1, -1}, {1, -1}, {-1, 1}]
    |> Enum.count(fn direction ->
      has_word_pattern(elem, position, pattern, direction, array, size)
    end)
  end

  defp find_pattern_starting(elem, position, [first, base, last], array, size, :cross) do
    directions = [{1, 1}, {-1, -1}, {1, -1}, {-1, 1}]

    if elem == base do
      has_cross_pattern(position, [first, first, last, last], directions, array, size)
    else
      0
    end
  end

  defp(has_cross_pattern(_, [], [], _, _), do: 1)

  defp has_cross_pattern(index, elems, [direction | directions], array, size) do
    case element_or_nil(array, index, direction, size) do
      nil ->
        0

      {elem, _, _} ->
        case List.delete(elems, elem) do
          l when l == elems -> 0
          new_elems -> has_cross_pattern(index, new_elems, directions, array, size)
        end
    end
  end

  defp has_word_pattern(elem, {r, c}, [e | pattern], direction, array, size) do
    if elem == e do
      case pattern do
        [] ->
          1

        pattern ->
          case element_or_nil(array, {r, c}, direction, size) do
            nil ->
              false

            {new_elem, ridx, cidx} ->
              has_word_pattern(new_elem, {ridx, cidx}, pattern, direction, array, size)
          end
      end
    else
      false
    end
  end

  defp element_or_nil(array, {r, c}, {dir_r, dir_c}, {max_r, max_c}) do
    ridx = r + dir_r
    cidx = c + dir_c

    if ridx >= 0 and cidx >= 0 and ridx < max_r and cidx < max_c do
      {line, _} = array[ridx]
      {elem, _} = line[cidx]
      {elem, ridx, cidx}
    end
  end

  defp array2d_size(array) do
    row_size = Arrays.size(array)
    {line, _} = array[0]
    col_size = Arrays.size(line)
    {row_size, col_size}
  end

  defp convert_to_indexed_array(input) do
    input
    |> String.trim()
    |> String.split(~r{(\r\n|\r|\n)})
    |> Enum.map(fn line ->
      line |> String.to_charlist() |> Enum.with_index(&as_tuple/2) |> Arrays.new()
    end)
    |> Enum.with_index(&as_tuple/2)
    |> Arrays.new()
  end

  defp as_tuple(element, index), do: {element, index}
end