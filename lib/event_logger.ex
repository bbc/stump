defmodule EventLogger do
  import Logger, only: [info: 1, warn: 1, error: 1]

  def info(data) when is_map(data) do
    Map.merge(data, %{datetime: DateTime.utc_now, level: "info"})
    |> Poison.encode!()
    |> Logger.inf
  end

  def info(data) when is_bitstring(data) do
    %{message: data, datetime: DateTime.utc_now, level: "info"}
    |> Poison.encode!()
    |> Logger.info
  end
end