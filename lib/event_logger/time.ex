defmodule Stump.Time do
  @callback utc_now() :: DateTime
end