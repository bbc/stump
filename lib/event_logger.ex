defmodule EventLogger do
  import Logger, only: [info: 1, warn: 1, error: 1]
  import String, only: [downcase: 1]

  def log(level, data) do
    case downcase(level) do
      "info"  -> data_type(level, data)   |> Logger.info
      "warn"  -> data_type(level, data)   |> Logger.warn
      "error" -> data_type(level, data)   |> Logger.error
      _       -> data_type("error", nil)  |> Logger.error
    end
  end

  def log(_) do
    data_type("error", "No input passed to EventLogger")
    |> Logger.error
  end

  defp data_type(level, data) do
    case data do
      nil          -> string(level, "Incorrect log level assigned to EventLogger")
      is_bitstring -> string(level, data)
      is_map       -> map(level, data)
    end
  end

  defp map(level, data) do
    Map.merge(data, %{datetime: DateTime.utc_now, level: to_string(level)})
    |> Poison.encode!()
  end

  defp string(level, data) do
    %{message: data, datetime: DateTime.utc_now, level: to_string(level)}
    |> Poison.encode!()
  end
end