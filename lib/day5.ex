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

    _part2 =
      pages_list
      |> Enum.filter(&(not follows_rules?(&1, rules)))
      |> Enum.map(&order_pages_by_rules(&1, rules))
      |> Enum.map(&sum_middle_number/1)
      |> Enum.sum()

    {part1, nil}
  end

  defp order_pages_by_rules(pages, rules) do
    rules
    |> Enum.reduce(%{}, &update_rules_map/2)
    |> Enum.reduce(Arrays.new(), &order_pages(&1, &2, pages))
  end

  defp update_rules_map({back, front}, map) do
    map
    |> Map.get_and_update(back, fn value ->
      if value == nil, do: MapSet.new([front]), else: MapSet.put(value, front)
    end)
    |> elem(1)
  end

  defp order_pages({_back, _front}, _pages, _acc) do
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
