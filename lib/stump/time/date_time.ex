defmodule Stump.Time.DateTime do
  @moduledoc false

  @doc """
  This function won't be listed in docs.
  """
  @behaviour Stump.Time
  import DateTime, only: [utc_now: 0]

  def utc_now() do
    DateTime.utc_now()
  end
end
