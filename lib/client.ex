defmodule Client do
  defp get do
    :inets.start
    {:ok, {_, _, content}} = :httpc.request 'http://localhost:9292'
    content
  end

  defp parse_content(content) do
    {:ok, result} = JSON.decode(content)
    result
  end

  defp log_results(%{"name" => name, "best_number" => best_number, "pi" => pi, "right_now" => right_now}) do
    IO.puts "Name: #{name}"
    IO.puts "PI: #{pi}"
    IO.puts "The Best Number: #{best_number}"
    IO.puts "Right Now: #{right_now}"
  end

  def get_JSON do
    get |> parse_content |> log_results
  end
end

Client.get_JSON
