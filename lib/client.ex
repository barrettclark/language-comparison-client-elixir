defmodule Client do
  defp get do
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

defmodule Spawner do
  def spawn_tasks(count, function) do
    1..count
      |> Enum.map( fn(_) -> Task.async(function) end )
      |> Enum.map( &Task.await/1 )
  end
end

defmodule SerialRunner do
  def execute(count, function) do
    1..count
      |> Enum.map( fn(_) -> function.() end)
  end
end

Client.get_JSON

connections = 100

IO.puts "running single web request for baseline"
{single_request_timing, _result} = :timer.tc(Client, :get_JSON, [])

IO.puts "running baseline tasks for timing"
{timing_tasks_baseline, _result} = :timer.tc(Spawner, :spawn_tasks, [connections, fn() -> 1 end])

IO.puts "running via tasks"
{timing_tasks, _result} = :timer.tc(Spawner, :spawn_tasks, [connections, &Client.get_JSON/0])

IO.puts "running via serial map"
{timing_serial, _result} = :timer.tc(SerialRunner, :execute, [connections, &Client.get_JSON/0])

IO.puts "running a sinle request took #{single_request_timing} microseconds"
IO.puts "running #{connections} baseline tasks took #{timing_tasks_baseline} microseconds"
IO.puts "running #{connections} tasks took #{timing_tasks} microseconds"
IO.puts "running #{connections} in a map took #{timing_serial} microseconds"
