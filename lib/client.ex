defmodule Client do
  defp get() do
    :inets.start()
    {:ok, {status, headers, content}} = :httpc.request 'http://localhost:9292'
    {status, headers, content}
  end

  defp parse({status, headers, content}) do
    {:ok, result} = JSON.decode(content)
    result
  end

  def getJSON() do
    get() |> parse
  end
end

jsonMap = Client.getJSON()
IO.puts "Name: " <> jsonMap["name"]
IO.puts "PI: " <> to_string(jsonMap["pi"])
IO.puts "The Best Number: " <> to_string(jsonMap["best_number"])
IO.puts "Right Now: " <> jsonMap["right_now"]
