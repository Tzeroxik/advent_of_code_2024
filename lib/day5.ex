defmodule Day5 do
  def run!(input) do
    {rules, pages_list} =
      input
      |> Util.split_lines()
      |> Enum.reduce([], &create_lists/2)

    part1 =
      pages_list
      |> Enum.filter(fn pages -> follows_rules?(pages, rules) end)
      |> Enum.map(&sum_middle_number/1)
      |> Enum.sum()

    part2 =
      input
      |> Enum.map(fn pages -> fix_failed_updates(pages, rules) end)

    {part1, part2}
  end

  def fix_pages(pages, rules) do
  end

  def fix_failed_updates(pages, rules) do
    cond do
      follows_rules?(pages, rules) -> pages
      true -> fix_pages(pages, rules)
    end
  end

  defp sum_middle_number(pages) do
    pages
    |> length()
    |> div(2)
    |> then(fn idx -> Enum.at(pages, idx) end)
  end

  defp do_follow_rule?([n1 | _], {n1, n2}, [n2]), do: false

  defp do_follow_rule?([n2 | _], {n1, n2}, [n1]), do: true

  defp do_follow_rule?([], _, _), do: true

  defp do_follow_rule?([page | pages], {n1, n2}, found_pages) do
    found_pages =
      if page == n1 or page == n2 do
        [page | found_pages]
      else
        found_pages
      end

    do_follow_rule?(pages, {n1, n2}, found_pages)
  end

  defp follows_rule?(pages, rules), do: do_follow_rule?(pages, rules, [])

  defp follows_rules?(pages, rules),
    do: Enum.all?(rules, fn rule -> follows_rule?(pages, rule) end)

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
