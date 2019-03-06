defmodule EventLogger do
  import Logger, only: [info: 1, warn: 1, error: 1]
  import String, only: [downcase: 1]

  def log(level, data) do
    case downcase(level) do
      "info"  -> info(level, data)
      "warn"  -> warn(level, data)
      "error" -> error(level, data)
    end
  end

  defp info(level, data) when is_map(data) do
    map(level, data)
    |> Logger.info
  end

  defp info(level, data) when is_bitstring(data) do
    string(level, data)
    |> Logger.info
  end

  defp warn(level, data) when is_map(data) do
    map(level, data)
    |> Logger.warn
  end

  defp warn(level, data) when is_bitstring(data) do
    string(level, data)
    |> Logger.warn
  end

  defp error(level, data) when is_map(data) do
    map(level, data)
    |> Logger.error
  end

  defp error(level, data) when is_bitstring(data) do
    string(level, data)
    |> Logger.error
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