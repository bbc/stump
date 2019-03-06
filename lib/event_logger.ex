defmodule EventLogger do
  import Logger, only: [info: 1, warn: 1, error: 1]

  def info(data) when is_map(data) do
    Map.merge(data, %{datetime: DateTime.utc_now, level: "info"})
    |> Poison.encode!()
    |> Logger.info
  end

  def info(data) when is_bitstring(data) do
    %{message: data, datetime: DateTime.utc_now, level: "info"}
    |> Poison.encode!()
    |> Logger.info
  end

  def warn(data) when is_map(data) do
    Map.merge(data, %{datetime: DateTime.utc_now, level: "warn"})
    |> Poison.encode!()
    |> Logger.warn
  end

  def warn(data) when is_bitstring(data) do
    %{message: data, datetime: DateTime.utc_now, level: "warn"}
    |> Poison.encode!()
    |> Logger.warn
  end

  def error(data) when is_map(data) do
    Map.merge(data, %{datetime: DateTIme.utc_now, level: "error"})
    |> Poison.encode!()
    |> Logger.error
  end

  def error(data) when is_bitstring(data) do
    %{message: data, datetime: DateTime.utc_now, level: "error"}
    |> Poison.encode!()
    |> Logger.error
  end
end