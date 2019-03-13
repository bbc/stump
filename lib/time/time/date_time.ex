defmodule Stump.Time.DateTime do
  @behaviour Stump.Time
  import DateTime, only: [utc_now: 0]

  def utc_now() do
    DateTime.utc_now()
  end
end