defmodule Stump do
  @moduledoc """
  Stump allows for Maps and Strings to be passed into the Elixir Logger and return logs in the JSON format.
  """
  @moduledoc since: "1.0.0"
  @doc """
  The `log` method formats your given error message whether it be a Map or a String then passes it to Elixirs own Logger.

  Usage for the module is as follows:

  ```
  Stump.log(:level, message)
  ```

  The level can be any of four `:debug/:info/:warn/:error`


  Message can be either a `String` or `Map`

  ```
    Stump.log(:error, 'Error Logged')
    {'message':'Error Logged','level':'error','datetime':'2019-03-06T12:21:52.661587Z'}
  ```
  """
  import Logger, only: [log: 2]

  def log(level, data) when level in [:error, :warn, :info] do
    Logger.log(level, format(level, data))
  end

  defp format(level, data) when data == nil or data == "" do
    format(level, "Event Logger received log level, but no error message was provided")
  end

  defp format(level, %_{} = struct) do
    format(level, Map.from_struct(struct))
  end

  defp format(level, data) when is_map(data) do
    data
    |> PhStTransform.transform(formatting_potion())
    |> Map.merge(%{datetime: time(), level: to_string(level)})
    |> encode()
  end

  defp format(level, data) when is_bitstring(data) or is_binary(data) do
    %{message: data, datetime: time(), level: to_string(level)}
    |> encode()
  end

  defp formatting_potion do
    %{
      Atom => fn atom -> Atom.to_string(atom) end,
      Tuple => fn tuple -> Tuple.to_list(tuple) end,
      Any => &other_types/1
    }
  end

  def other_types(struct) when is_map(struct) do
    if Map.has_key?(struct, :__struct__) do
      Map.from_struct(struct)
    else
      struct
    end
  end

  def other_types(unknown), do: unknown

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
