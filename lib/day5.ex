defmodule Day5 do
  def run!(input) do
    {rules, pages} =
      input
      |> Util.split_lines()
      |> Enum.reduce([], &create_lists/2)
  end

  defp create_lists(line, rules) when line == "", do: {rules, []}

  defp create_lists(line, rules) when is_list(rules) do
    line
    |> split_entry_to_int_list("|")
    |> List.to_tuple()
    |> then(fn rule -> [rule | rules] end)
  end

  defp create_lists(line, {rules, pages}) do
    line
    |> split_entry_to_int_list(",")
    |> then(fn page -> {rules, [page | pages]} end)
  end

  defp split_entry_to_int_list(line, separator) do
    line
    |> String.split(separator)
    |> Enum.map(&String.to_integer/1)
  end
end
