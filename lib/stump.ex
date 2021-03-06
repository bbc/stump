defmodule Stump do
  @moduledoc """
  Stump allows for Maps and Strings to be passed into the Elixir Logger and return logs in the JSON format.
  """
  @moduledoc since: "1.6.2"
  @doc """
  The `log` method formats your given error message whether it be a Map or a String then passes it to Elixirs own Logger.

  Usage for the module is as follows:

  ```
  Stump.log(level, message)
  ```

  The level can be any of four `:debug/:info/:warn/:error`

  Message can be either a `String` or `Map`

  ```
    Stump.log(:error, 'Error Logged')
    {'message':'Error Logged','level':'error','datetime':'2019-03-06T12:21:52.661587Z'}
  ```
  """
  import Logger, only: [log: 2]

  def log(level, data, metadata \\ []) when level in [:error, :warn, :info, :debug] do
    Logger.log(level, format(level, data), metadata)
  end

  def metadata(keyword) do
    Logger.metadata(keyword)
  end

  def metadata() do
    Map.new(Logger.metadata())
  end

  defp format(level, data) when data == nil or data == "" do
    format(level, "Event Logger received log level, but no error message was provided")
  end

  defp format(level, %_{} = struct) do
    format(level, Map.from_struct(struct))
  end

  defp format(level, data) when is_map(data) do
    data
    |> destruct()
    |> Map.merge(%{datetime: time(), level: to_string(level), metadata: metadata()})
    |> encode()
  end

  defp format(level, data) when is_bitstring(data) or is_binary(data) do
    %{message: data, datetime: time(), level: to_string(level), metadata: metadata()}
    |> encode()
  end

  defp destruct(struct = %_{}) do
    struct
    |> Map.from_struct()
    |> destruct()
  end

  defp destruct(map) when is_map(map) do
    Enum.into(map, %{}, fn {k, v} -> {k, destruct(v)} end)
  end

  defp destruct(data) when is_tuple(data) do
    data
    |> Tuple.to_list()
    |> destruct()
  end

  defp destruct(data) when is_list(data) do
    Enum.map(data, fn x -> destruct(x) end)
  end

  defp destruct(data) when is_reference(data) do
    "#Ref<>"
  end

  defp destruct(data) when is_pid(data) do
    "#Pid<>"
  end

  defp destruct(data), do: data

  defp encode(map) do
    case Jason.encode(map) do
      {:ok, value} ->
        value

      {:error, _} ->
        encode(%{
          jason_error: "Jason returned an error encoding your log message",
          raw_log: Kernel.inspect(map),
          datetime: time()
        })
    end
  end

  @doc false
  def time() do
    Application.get_env(:stump, :time_api).utc_now()
  end
end
