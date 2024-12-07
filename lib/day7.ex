defmodule Day7 do
  def run!(input) do
    part1 = solve(input, [&+/2, &*/2])
    part2 = solve(input, [&+/2, &*/2, &append/2])
    {part1, part2}
  end

  defp solve(input, operators) do
    input
    |> Util.split_lines()
    |> Enum.map(&split_members/1)
    |> Enum.filter(&is_valid_configuration(&1, operators))
    |> Enum.map(fn [result | _] -> result end)
    |> Enum.sum()
  end

  defp append(a, b) when is_integer(a) and is_integer(b) do
    [a, b]
    |> Enum.map(&Integer.to_string/1)
    |> Enum.join()
    |> String.to_integer()
  end

  defp split_members(line) do
    line
    |> String.split(" ")
    |> Enum.map(fn line -> line |> String.trim(":") |> String.to_integer() end)
  end

  defp is_valid_configuration(values, operators) do
    values
    |> operation_configurations(operators)
    |> Enum.count()
    |> then(&(&1 > 0))
  end

  defp operation_configurations([result, first | operands], operators) do
    operation_configurations(operators, operands, result, [first])
  end

  defp operation_configurations(_, [], result, acc), do: acc |> Enum.filter(&(&1 == result))

  defp operation_configurations(operators, [value | operands], result, acc) do
    acc
    |> Enum.filter(&(&1 <= result))
    |> Enum.flat_map(fn cumulative -> Enum.map(operators, fn op -> op.(cumulative, value) end) end)
    |> then(&operation_configurations(operators, operands, result, &1))
  end
end
