# EventLogger

EventLogger is an Elixir log wrapper that allows you to pass Maps into the built in Logger function, returning them in a JSON format and outputting to a file in Production mode.
Providing you with the ability to write more descriptive log messages and send logs to services expecting logs in the json/map format.

## Usage
Once the packages has been installed into your package we recommend usage as so:

```elixir
  alias EventLogger.{error}, as: Log

  def foo do
    Log.error(%{message: "Error Logged"})
  end
```

Providing you with output in this format:

 ```
  {"message":"Error Logged","level":"error","datetime":"2019-03-06T12:18:24.179731Z"}
  :ok
```

You can also pass in strings if you would prefer not to use maps:

```elixir
  iex(1)> alias EventLogger.Error, as: Log
  EventLogger.Error
  iex(2)> Log.error("Error Logged")
  :ok
  {"message":"Error Logged","level":"error","datetime":"2019-03-06T12:21:52.661587Z"}
  iex(3)> 
```

It can also be nicely used in conjuction with libraries such as [HTTPoison](https://github.com/edgurgel/httpoison)

```elixir
  alias EventLogger.error, as: Log

  def process(_, {:error, %HTTPoison.Error{reason: reason}}) do
    Log.error(%{message: "Failed to process HTTP request, reason: #{reason}", event: "HTTPoison.Error"})
    {:error, reason}
  end
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `event_logger` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:event_logger, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/event_logger](https://hexdocs.pm/event_logger).

