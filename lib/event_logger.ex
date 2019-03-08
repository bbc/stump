defmodule EventLogger do
  import Logger, only: [log: 2]

  @time EventLogger.Time.MockTime

  def log(level, data) when level in [:error, :warn, :info] do
    Logger.log(level, format(level, data))
  end

  defp format(level, data) when data == nil or data == "" do
    format(level, "Event Logger received log level, but no error message was provided")
  end

  defp format(level, data) when is_map(data) do
    Map.merge(data, %{datetime: time(), level: to_string(level)})
    |> Poison.encode!()
  end

  defp format(level, data) when is_bitstring(data) or is_binary(data) do
    %{message: data, datetime: time(), level: to_string(level)}
    |> Poison.encode!()
  end

  def time() do
    @time.utc_now()
  end
end