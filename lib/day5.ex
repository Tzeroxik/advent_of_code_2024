defmodule Day5 do
  def run!(input) do
    {rules, pages} =
      input
      |> Util.split_lines()
      |> Enum.reduce([], &create_lists/2)
  end

  defp create_lists(line, rules) when line == "", do: {rules, []}

  defp create_lists(line, rules) when is_list(rules) do
    rule = split_entry_to_int_list(line, "|") |> List.to_tuple()
    [rule | rules]
  end

  defp create_lists(line, {rules, pages}) do
    page = split_entry_to_int_list(line, ",")
    {rules, [page | pages]}
  end

  defp split_entry_to_int_list(line, separator) do
    line
    |> String.split(separator)
    |> Enum.map(&String.to_integer/1)
  end
end
