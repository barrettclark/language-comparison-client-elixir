defmodule Client do
  defp get() do
    :inets.start()
    {:ok, {_, _, content}} = :httpc.request 'http://localhost:9292'
    content
  end

  defp parseContent(content) do
    {:ok, result} = JSON.decode(content)
    result
  end

  defp logResults(jsonMap) do
    pi         = jsonMap["pi"] |> to_string
    bestNumber = jsonMap["best_number"] |> to_string
    IO.puts "Name: " <> jsonMap["name"]
    IO.puts "PI: " <> pi
    IO.puts "The Best Number: " <> bestNumber
    IO.puts "Right Now: " <> jsonMap["right_now"]
  end

  def getJSON() do
    get |> parseContent |> logResults
  end
end

Client.getJSON()
