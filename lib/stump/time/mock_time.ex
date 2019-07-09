defmodule Stump.Time.MockTime do
  @moduledoc false

  @doc """
  This function won't be listed in docs.
  """
  @behaviour Stump.Time

  def utc_now() do
    # It's always 1st March 2019
    DateTime.from_unix!(01_551_398_400)
  end
end
