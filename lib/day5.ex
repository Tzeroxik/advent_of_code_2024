defmodule Day5 do
  def run!(input) do
    {rules, pages_list} =
      input
      |> Util.split_lines()
      |> Enum.reduce([], &create_lists/2)

    part1 =
      pages_list
      |> Enum.filter(&follows_rules?(&1, rules))
      |> Enum.map(&sum_middle_number/1)
      |> Enum.sum()

    part2 =
      pages_list
      |> Enum.map(&map_pages(&1, rules))
      |> Enum.map(&sum_middle_number/1)
      |> Enum.sum()

    {part1, part2}
  end

  defp map_pages(pages, rules) do
    pages
    |> with_broken_rules(rules)
    |> process_broken_rules()
  end

  defp with_broken_rules(pages, rules) do
    rules
    |> Enum.count(fn rule -> not follows_rule?(pages, rule) end)
    |> then(&{pages, rules, &1})
  end

  defp process_broken_rules({pages, rules, broken_rule_count}) do
    case broken_rule_count do
      0 -> pages
      _ -> fix_rules(pages, rules)
    end
  end

  defp fix_rules(pages, rules) do
    IO.inspect(rules)
    IO.inspect(pages)
    [0]
  end

  defp follows_rules?(pages, rules), do: Enum.all?(rules, &follows_rule?(pages, &1))

  defp follows_rule?(pages, rules), do: do_follow_rule?(pages, rules, [])

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

  defp sum_middle_number(pages) do
    pages
    |> length()
    |> div(2)
    |> then(&Enum.at(pages, &1))
  end

  defp create_lists(line, rules) when line == "", do: {rules, []}

  defp create_lists(line, rules) when is_list(rules) do
    line
    |> split_entry_to_int_list("|")
    |> List.to_tuple()
    |> then(&[&1 | rules])
  end

  defp create_lists(line, {rules, pages}) do
    line
    |> split_entry_to_int_list(",")
    |> then(&{rules, [&1 | pages]})
  end

  defp split_entry_to_int_list(line, separator) do
    line
    |> String.split(separator)
    |> Enum.map(&String.to_integer/1)
  end
end
