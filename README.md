# EventLogger

EventLogger is an Elixir log wrapper that allows you to pass Maps into the built in Logger function, returning them in a JSON format and outputting to a file in Production mode.
Providing you with the ability to write more descriptive log messages and send logs to services expecting logs in the json/map format.
The library isnt limited to maps, it can also take in strings and create JSON formatted log messages.

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

## Usage
Once the packages has been installed into your package we recommend usage as so:

```elixir
  def foo do
    EventLogger.log(:error, %{message: "Error Logged"})
  end
```

Providing you with output in this format:
 ```elixir
  {"message":"Error Logged","level":"error","datetime":"2019-03-06T12:18:24.179731Z"}
  :ok
```

You can also pass in strings if you would prefer not to use maps:

```elixir
  Log.error(:error, "Error Logged")
  {"message":"Error Logged","level":"error","datetime":"2019-03-06T12:21:52.661587Z"}
```

It can also be nicely used in conjuction with libraries such as [HTTPoison](https://github.com/edgurgel/httpoison)

```elixir
  def process(_, {:error, %HTTPoison.Error{reason: reason}}) do
    EventLogger.log(:error, %{message: "Failed to process HTTP request, reason: #{reason}", event: "HTTPoison.Error"})
    {:error, reason}
  end
```

## Configuration

The default configuration for this will simply log to the console, if you would like to configure it you can simply edit your `config.exs` file.
It is worth noting that you must keep the format as `format: "$message\n"` with whichever logging backend you choose to use otherwise you will get duplication of information.

For example if you would like to Log to a file the following configuration would be recommended:

- First edit your `mix.exs` and add the LoggerFileBackend

```elixir
  defp deps do
    [
      {:logger_file_backend, "~> 0.0.10"}
    ]
  end
```

- Run mix deps.get

- Edit your `config.exs`

```elixir
config :logger,
  backends: [{LoggerFileBackend, :file}]

config :logger, :file,
  path: "/var/log/my_app/error.log",
  format: "$message\n",
  level: :debug
```