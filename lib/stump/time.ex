defmodule Stump.Time do
  @moduledoc false

  @doc """
  This function won't be listed in docs.
  """
  @callback utc_now() :: DateTime
end