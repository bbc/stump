defmodule EventLogger.Time do
  @callback utc_now() :: DateTime
end