defmodule EventLogger do
  import Logger, only: [info: 1, warn: 1, error: 1]
  import String, only: [downcase: 1]

  def log(level, data) do
    case level do
      :info  -> data_type(level, data) |> Logger.info
      :warn  -> data_type(level, data) |> Logger.warn
      :error -> data_type(level, data) |> Logger.error
      _      -> data_type("error", "Incorrect log level assigned to EventLogger") |> Logger.error
    end
  end

  defp data_type(level, data) do
    case data do
      nil          -> string(level, "Event Logger received log level, but no error message was provided")
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